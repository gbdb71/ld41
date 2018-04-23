export class AlienEnemy extends Enemy
    new: =>
        super(1)
        with @graphic = Animation("#{Settings.folders.graphics}/alien.png", 25, 20)
            .origin.x = 18
            .origin.y = 13
            \addTrack("walk", "1-4", 130)\loop()
            \addTrack("death", "5-10", 130)
            \play("walk")

        @attackRange = {
            {  0, -1 }
            {  1,  0 }
            {  0,  1 }
            { -1,  0 }
        }

        @movementRange = {
            {  0, -1 }
            {  1,  0 }
            {  0,  1 }
            { -1,  0 }
        }

        @movement = @addComponent(Movement(100, 100, 300, 300))
        @nextMove = x: 0, y: 0

    draw: =>
        super!
        if (not @isAlive)
            return

    -- health
    onDeath: =>
        super!
        @graphic\play("death")


    -- planning
    plan: (time) =>
        super(time)
        @nextMove.x, @nextMove.y = @getRandomMove!
        @hasFinishedPlanning = true

    onThink: (dt) =>
        super(dt)

    executePlan: =>
        super!
        if (@nextMove.x != 0 or @nextMove.y != 0)
            @move(@nextMove.x, @nextMove.y)
