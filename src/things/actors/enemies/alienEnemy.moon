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

        with @movement = @addComponent(Movement(500, 500, 800, 800))
            .callbacks.onEndMove = ->
                if (not @attack!)
                    @finishTurn!

        -- attack
        @damage = 1
        @performingAttack = false
        @attacked = nil

        -- attack tween
        @attackTween = nil
        @playingAttackTween = false
        @attackTweenDir = 1
        @attackMoveDistance = 14

        @nextMove = x: 0, y: 0

    update: (dt) =>
        super(dt)
        if (not @isAlive)
            return

        if (@playingAttackTween)
            if (@attackTween\update(dt * @attackTweenDir))
                if (@attackTweenDir > 0)
                    @attackTweenDir *= -1
            elseif (@attackTween.clock <= 0)
                @playingAttackTween = false
                @attacked\takeDamage(@damage)
                @finishTurn!

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
        if (not @isAlive)
            return

        local playerCell

        -- try to find if player is on a neighbor cell
        -- moving bias to player
        for _, attackRange in pairs @attackRange
            cell = @neighborCell(attackRange[1], attackRange[2])
            if (not cell\hasPlayer!)
                continue

            playerCell = cell
            @nextMove.x, @nextMove.y = attackRange[1], attackRange[2]
            break

        -- if doesn't player had found, move to a random direction
        if (playerCell == nil)
            @nextMove.x, @nextMove.y = @getRandomMove!

        --@nextMove.x, @nextMove.y = 0, 0
        @hasFinishedPlanning = true

    onThink: (dt) =>
        super(dt)

    executePlan: =>
        super!
        if (not @isAlive)
            return

        if (not @move(@nextMove.x, @nextMove.y) and not @playingAttackTween)
            @finishTurn!

    -- attack
    attack: =>
        if (not @isAlive)
            return

        attackedCell = @facingCell!

        if (attackedCell == nil or attackedCell.thing == nil)
            return false

        print "attack"
        if (attackedCell\hasPlayer!)
            Settings.audio.content.sfx["alienAttack"]\play!
            print "performing attack"
            @attacked = attackedCell.thing

            faceX, faceY = Helper.directionToVector(@faceDirection)
            attackX = @x + faceX * @attackMoveDistance
            attackY = @y + faceY * @attackMoveDistance
            @attackTween = Tween.new(.2, @, { x: attackX, y: attackY }, "inCubic")
            @playingAttackTween = true
            @attackTweenDir = 1
            return true

        return false


    onCollideThing: (thing) =>
        switch (thing.__class.__name)
            when "Player"
                -- attack
                @attack!
                return true

        return true
