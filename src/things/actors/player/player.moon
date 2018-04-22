export class Player extends Actor
    new: =>
        super!
        @graphic = Image("#{Settings.folders.graphics}/player.png")
        with @graphic = Animation("#{Settings.folders.graphics}/player.png", 17, 23)
            --.origin.x = 10
            .origin.y = 7
            \addTrack("idle", "1-4", 130)\loop()
            \play("idle")

        @movement = @addComponent(Movement(100, 100, 300, 300))

    draw: =>
        super!
