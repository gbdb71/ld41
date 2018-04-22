export class Player extends Actor
    new: =>
        super(2)
        @damage = 1
        with @graphic = Animation("#{Settings.folders.graphics}/player.png", 17, 24)
            .origin.x = 8
            .origin.y = 19
            \addTrack("idle", "1-4", 130)\loop()
            \addTrack("jump", "5-7", 130)
            \play("idle")

        with @movement = @addComponent(Movement(100, 100, 300, 300))
            .callbacks.onStartMove = ->
                @graphic\play("jump")

            .callbacks.onMoving = ->

            .callbacks.onEndMove = ->
                @graphic\play("idle")
                @attack!

    draw: =>
        super!
        if (@lastAttackX != nil)
            love.graphics.rectangle("fill", @lastAttackX - 16, @lastAttackY - 16, 16, 16)


    attack: =>
        faceX, faceY = Helper.directionToVector(@faceDirection)
        facingCell = @scene.grid\cellAt(@currentGrid.x + faceX, @currentGrid.y + faceY)

        if (facingCell == nil or facingCell.thing == nil)
            return false

        @lastAttackX, @lastAttackY = @scene.grid\transformToPos(@currentGrid.x + faceX, @currentGrid.y + faceY)

        print facingCell.thing.__class.__parent.__name
        switch (facingCell.thing.__class.__parent.__name)
            when "Enemy"
                facingCell.thing\takeDamage(@damage)
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
