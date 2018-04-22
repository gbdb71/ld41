export class AlienEnemy extends Enemy
    new: =>
        super(1)
        with @graphic = Animation("#{Settings.folders.graphics}/alien.png", 25, 20)
            .origin.x = 18
            .origin.y = 13
            \addTrack("walk", "1-4", 130)\loop()
            \addTrack("death", "5-10", 130)
            \play("walk")

    onDeath: =>
        print "#{@@__name} death"
        @graphic\play("death")


    updateTurn: (dt, turn) =>
        super(dt, turn)
        @finishTurn!
