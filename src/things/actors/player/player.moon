export class Player extends Actor
    new: =>
        super(3)
        @damage = 1
        with @graphic = Animation("#{Settings.folders.graphics}/player.png", 17, 24)
            .origin.x = 8
            .origin.y = 19
            \addTrack("idle", "1-4", 130)\loop()
            \addTrack("jump", "5-7", 130)
            \play("idle")

        with @attackGraphic = ImageSet("#{Settings.folders.graphics}/player_attack.png", 22, 22)
            .frameDuration = .050
            .callbacks.onEnd = -> @attackedEnemy\takeDamage(@damage)

        with @movement = @addComponent(Movement(100, 100, 300, 300))
            .callbacks.onStartMove = ->
                @graphic\play("jump")

            .callbacks.onMoving = ->

            .callbacks.onEndMove = ->
                @graphic\play("idle")
                @attack!

        @attackedEnemy = nil


    update: (dt) =>
        super(dt)
        if (@attackGraphic.isPlaying)
            @attackGraphic\update(dt)

    draw: =>
        super!
        --if (@lastAttackX != nil)
        --    love.graphics.rectangle("fill", @lastAttackX - 16, @lastAttackY - 16, 16, 16)

        if (@attackGraphic.isPlaying)
            if (@graphic.flip.h)
                @attackGraphic\draw(@x - 3, @y - 15)
            else
                @attackGraphic\draw(@x + 3, @y - 15)


    attack: =>
        faceX, faceY = Helper.directionToVector(@faceDirection)
        facingCell = @scene.grid\cellAt(@currentGrid.x + faceX, @currentGrid.y + faceY)

        if (facingCell == nil or facingCell.thing == nil)
            return false

        --@lastAttackX, @lastAttackY = @scene.grid\transformToPos(@currentGrid.x + faceX, @currentGrid.y + faceY)

        switch (facingCell.thing.__class.__parent.__name)
            when "Enemy"
                --facingCell.thing\takeDamage(@damage)
                @attackedEnemy = facingCell.thing
                @attackGraphic\play!
                return true

        return false


    onCollideThing: (thing) =>
        switch (thing.__class.__parent.__name)
            when "Enemy"
                -- attack
                @attack!
                return true
            --when "Pickup"
            else
                print "'#{@@__name}' Collided with a undefined Thing '#{thing.__class.__name}' (parent: '#{thing.__parent.__class.__name}')"

        return false
