export class Enemy extends Actor
    @@attackRangeMarker = nil

    new: (maxHealth) =>
        super(maxHealth)
        @clock = 0

        -- planning
        @isPlanning = false
        @hasFinishedPlanning = false
        @endPlanTimer = 0
        @planningTime = Settings.enemyDefaultPlanningTime
        @attackRange = {}
        @movementRange = {}

    update: (dt) =>
        super(dt)

    gridDraw: (gridX, gridY, cellsOpacity) =>
        if (not @isWaiting or not @isAlive)
            return

        x = 0
        y = 0
        for _, gridPos in ipairs @attackRange
            x = @currentGrid.x + gridPos[1]
            y = @currentGrid.y + gridPos[2]
            cell = @scene.grid\cellAt(x, y)

            if (cell == nil or not cell.walkable)
                continue

            if (cell.thing != nil and cell.thing.__class.__name == "Player")
                for i = 1, 3
                    @@attackRangeMarker.color[i] = Settings.enemyAttackRangeOnPlayerMarkerColor[i]

            @@attackRangeMarker.opacity = cellsOpacity
            @@attackRangeMarker\draw(gridX + (x - 1) * Settings.tileSize.width, gridY + (y - 1) * Settings.tileSize.height)

            for i = 1, 3
                @@attackRangeMarker.color[i] = 1


    --turn
    startTurn: (turn) =>
        super(turn)
        if (not @isAlive)
            return

        @plan(@planningTime)

    updateTurn: (dt, turn) =>
        super(dt, turn)
        @clock += dt
        if (@isPlanning)
            @onThink(dt)
            if (@clock >= @endPlanTimer and @hasFinishedPlanning)
                @isPlanning = false
                @executePlan!
                @hasFinishedPlanning = false

    endTurn: (turn) =>
        if (not @isAlive)
            @canTurn = false

    -- health
    onDeath: =>
        print "#{@@__name} death"
        cell = @currentCell!
        cell.thing = nil
        @canTurn = false


    -- planning
    plan: (time) =>
        @isPlanning = true
        @endPlanTimer = @clock + time

    onThink: (dt) =>

    executePlan: =>

    -- util
    getRandomMove: =>
        local randomMove
        local randomCell

        maxTries = 4
        tries = 0
        while (randomCell == nil or not randomCell.walkable or (randomCell.thing != nil and (randomCell.thing.__class.__name == "Enemy" or randomCell.thing.__class.__name == "Projectile")))
            randomMove = Lume.randomchoice(@movementRange)
            randomCell = @scene.grid\cellAt(@currentGrid.x + randomMove[1], @currentGrid.y + randomMove[2])

            tries += 1
            if (tries > maxTries)
                return 0, 0

        return randomMove[1], randomMove[2]
