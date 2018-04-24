export class Player extends Actor
    new: =>
        super(3)

        -- damage
        @damage = 1
        @willTakeDamageAfterMoveTo = nil

        -- gems
        @gems = 0

        -- graphics
        with @graphic = Animation("#{Settings.folders.graphics}/player.png", 17, 24)
            .origin.x = 8
            .origin.y = 19
            \addTrack("idle", "1-4", 130)\loop()
            \addTrack("jump", "5-7", 130)
            \addTrack("death", "8-23", 130)\onEnd( -> @scene\callBadEnd! )
            \play("idle")

        with @attackGraphic = ImageSet("#{Settings.folders.graphics}/player_attack.png", 18, 19)
            .origin.x = 11
            .origin.y = 12
            .frameDuration = .080
            .callbacks.onEnd = -> @attackedEnemy\takeDamage(@damage)

        @attackTween = nil
        @playingAttackTween = false

        @attackOrigin = {
            right: { x: 3, y: -13 }
            left: { x: -3, y: -13 }
        }

        -- movement
        with @movement = @addComponent(Movement(100, 100, 300, 300))
            .callbacks.onStartMove = ->
                @graphic\play("jump")
                Settings.audio.content.sfx["playerMove"]\play!

            .callbacks.onMoving = ->

            .callbacks.onEndMove = ->
                @graphic\play("idle")
                if (@willTakeDamageAfterMoveTo != nil)
                    switch @willTakeDamageAfterMoveTo.__class.__name
                        when "SeedBullet"
                            @takeDamage(@willTakeDamageAfterMoveTo.damage)
                            @willTakeDamageAfterMoveTo\die!

                    @willTakeDamageAfterMoveTo = nil
                    if (not @isAlive)
                        return

                if (not @attack!)
                    @finishTurn!

        -- attack
        @attackedEnemy = nil


    update: (dt) =>
        super(dt)
        if (@attackGraphic.isPlaying)
            @attackGraphic\update(dt)

        if (@playingAttackTween)
            if (@attackTween\update(dt))
                @playingAttackTween = false
                @finishTurn!

    lateUpdate: =>
        super!
        if (not @isAlive)
            return

        cell = @currentCell!
        if (cell\hasPickup!)
            cell.pickup\collect(@)

    draw: =>
        super!
        if (@playingAttackTween)
            @attackGraphic\draw!

    -- health
    onDeath: =>
        Settings.audio.content.sfx["playerDeath"]\play!
        @graphic\play("death")

    attack: =>
        attackedCell = @facingCell!

        if (attackedCell == nil)
            return false

        if (attackedCell\hasEnemy! and attackedCell.thing.canTakeDamage)
            --facingCell.thing\takeDamage(@damage)
            @attackedEnemy = attackedCell.thing
            @attackGraphic\play!
            Settings.audio.content.sfx["laser"]\play!

            -- tween
            @playingAttackTween = true

            local attackOrigin
            if (@graphic.flip.h)
                attackOrigin = @attackOrigin.right
            else
                attackOrigin = @attackOrigin.left

            @attackGraphic.x = @x + attackOrigin.x
            @attackGraphic.y = @y + attackOrigin.y
            @attackTween = Tween.new(.7, @attackGraphic, { x: @attackedEnemy.x, y: @attackedEnemy.y }, "outCubic")
            return true

        return false


    onCollideThing: (thing) =>
        if (thing.__class.__name == "Chest")
            thing\open!
            return true

        switch (thing.__class.__parent.__name)
            when "Enemy"
                if (thing.__class.__name == "SeedBullet")
                    @willTakeDamageAfterMoveTo = thing
                    return false

                -- attack
                @attack!
                return true
            else
                print "'#{@@__name}' Collided with a undefined Thing '#{thing.__class.__name}' (parent: '#{thing.__parent.__class.__name}')"

        return true
