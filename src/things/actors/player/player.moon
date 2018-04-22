export class Player extends Actor
    new: =>
        super!
        @graphic = Image("#{Settings.folders.graphics}/player.png")
        with @graphic = Animation("#{Settings.folders.graphics}/player.png", 17, 24)
            --.origin.x = 10
            .origin.y = 7
            \addTrack("idle", "1-4", 130)\loop()
            \addTrack("jump", "5-7", 130)
            \play("idle")

        with @movement = @addComponent(Movement(100, 100, 300, 300))
            .callbacks.onStartMove = ->
                @graphic\play("jump")

            .callbacks.onEndMove = ->
                @graphic\play("idle")

    draw: =>
        super!


    onMoving: =>
