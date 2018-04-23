export class Actor extends Entity
    new: (maxHealth) =>
        super!
        @layer = Settings.layers.entity.actors

        @faceDirection = "left"

        -- health
        @maxHealth = maxHealth
        @health = @maxHealth
        @isAlive = true

        -- moving
        @movement = nil
        @isMoving = false
        @moveDirection = x: 0, y: 0

        -- grid
        @currentGrid = x: 0, y: 0

        -- turn
        @isWaiting = true
        @hasEndedTurn = false
        @canTurn = true


    sceneAdded: (scene) =>
        super(scene)
        @currentGrid.x, @currentGrid.y = @scene.grid\transformToGridPos(@x, @y)
        cell = @currentCell!

        if (cell.thing != nil)
            die!
            return

        cell.thing = @



    beforeUpdate: =>
        super!

    update: (dt) =>
        super(dt)
        if (not @isAlive or @movement == nil)
            return

        if (@isMoving and not @movement.hasTargetPosition)
            @isMoving = false
            @moveDirection.x = 0
            @moveDirection.y = 0

    lateUpdate: =>
        super!
        @currentGrid.x, @currentGrid.y = @scene.grid\transformToGridPos(@x, @y)

        if (not @isAlive)
            return

        curentCell = @currentCell!
        if (currentCell != nil)
            -- check if current tile isn't walkable (impossible situation, but actor dies)
            if (not currentCell.walkable)
                @die!


    draw: =>
        super!
        if (@movement == nil or (@movement.targetPosition.x == 0 and @movement.targetPosition.y == 0))
            return

        love.graphics.setColor(1, 0, 0, .7)
        love.graphics.line(@x, @y, @movement.targetPosition.x, @movement.targetPosition.y)
        love.graphics.setColor(1, 1, 1, .7)


    -- turn
    startTurn: (turn) =>
        @isWaiting = false

    updateTurn: (dt, turn) =>

    endTurn: (turn) =>

    finishTurn: =>
        if (@isWaiting)
            return

        @hasEndedTurn = true
        @isWaiting = true


    -- movement
    move: (x, y) =>
        if (@isMoving or (x == 0 and y == 0))
            return false

        if (x > 0)
            @turnTo("right")
        elseif (x < 0)
            @turnTo("left")
        elseif (y < 0)
            @turnTo("up")
        elseif (y > 0)
            @turnTo("down")

        nextGrid =
            x: @currentGrid.x + x
            y: @currentGrid.y + y

        nextCell = @scene.grid\cellAt(nextGrid.x, nextGrid.y)

        -- check if next tile is walkable
        if (nextCell == nil or not nextCell.walkable)
            if (@onCollideCell(nextCell))
                return false
        elseif (nextCell.thing != nil)
            if (@onCollideCell(nextCell))
                return false

        -- moving
        cell = @currentCell!
        cell.thing = nil
        nextCell.thing = @
        @isMoving = true
        @moveDirection.x = x
        @moveDirection.y = y
        @movement\moveTo(
            @x + @moveDirection.x * Settings.tileSize.width
            @y + @moveDirection.y * Settings.tileSize.height
        )

        return true

    moveUp: (tiles=1) =>
        @move(0, -tiles)

    moveRight: (tiles=1) =>
        @move(tiles, 0)

    moveDown: (tiles=1) =>
        @move(0, tiles)

    moveLeft: (tiles=1) =>
        @move(-tiles, 0)

    turnTo: (direction) =>
        @faceDirection = direction
        if (@graphic != nil)
            faceX, faceY = Helper.directionToVector(@faceDirection)
            if (faceX != 0)
                @graphic.flip.h = (faceX > 0)


    -- health
    changeHealth: (amount) =>
        @health = Lume.clamp(@health + amount, 0, @maxHealth)

    takeDamage: (amount) =>
        if (amount == 0 or not @isAlive)
            return

        if (amount < 0)
            @takeHeal(math.abs(amount))
            return

        @changeHealth(-amount)
        if (not @onTakeDamage!)
            @changeHealth(amount)
            return

        if (@health == 0)
            @die!

    takeHeal: (amount) =>
        if (amount == 0 or not @isAlive)
            return

        if (amount < 0)
            @takeDamage(math.abs(amount))
            return

        @changeHealth(amount)
        if (not @onTakeHeal!)
            @changeHealth(-amount)
            return

    onTakeDamage: =>
        print "#{@@__name} take damage [#{@health}/#{@maxHealth}]"
        return true

    onTakeHeal: =>
        print "#{@@__name} take heal [#{@health}/#{@maxHealth}]"
        return true

    die: =>
        if (not @isAlive)
            return

        @isAlive = false
        print "#{@@__name} dies"
        @health = 0
        @onDeath!

    onDeath: =>
        @removeSelf!


    -- grid cell
    currentCell: =>
        @scene.grid\cellAt(@currentGrid.x, @currentGrid.y)

    neighborCell: (x, y) =>
        @scene.grid\cellAt(@currentGrid.x + x, @currentGrid.y + y)

    facingCell: =>
        faceX, faceY = Helper.directionToVector(@faceDirection)
        @neighborCell(faceX, faceY)

    -- collision
    onCollideCell: (cell) =>
        if (cell == nil or not cell.walkable)
            return true
        elseif (cell.thing != nil and cell.thing.__class.__parent != nil)
            if (@onCollideThing(cell.thing))
                return true

        return false

    onCollideThing: (thing) =>
        return true
