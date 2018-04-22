export class Actor extends Entity
    new: =>
        super!
        @layer = Settings.layers.entity.actors

        -- moving
        @movement = nil
        @isMoving = false
        @moveDirection = x: 0, y: 0

        -- grid
        @currentGrid = x: 0, y: 0

        -- turn
        @isWaiting = true
        @hasEndedTurn = false


    sceneAdded: (scene) =>
        super(scene)
        @currentGrid.x, @currentGrid.y = @scene.grid\transformToGridPos(@x, @y)


    beforeUpdate: =>
        super!

    update: (dt) =>
        super(dt)
        if (@isMoving and not @movement.hasTargetPosition)
            @isMoving = false
            @moveDirection.x = 0
            @moveDirection.y = 0

    lateUpdate: =>
        @currentGrid.x, @currentGrid.y = @scene.grid\transformToGridPos(@x, @y)

        curentCell = @currentCell!
        if (currentCell != nil)
            -- check if current tile isn't walkable (impossible situation, but actor dies)
            if (not currentCell.walkable)
                @die!


    draw: =>
        super!
        --love.graphics.rectangle("fill", @movement.targetPosition.x, @movement.targetPosition.y, 1, 1)


    startTurn: (turn) =>
        @isWaiting = false

    updateTurn: (dt, turn) =>

    endTurn: (turn) =>

    finishTurn: =>
        if (@isWaiting)
            return

        @hasEndedTurn = true
        @isWaiting = true


    move: (x, y) =>
        if (@isMoving or (x == 0 and y == 0))
            return false

        nextGrid =
            x: @currentGrid.x + x
            y: @currentGrid.y + y

        nextCell = @scene.grid\cellAt(nextGrid.x, nextGrid.y)

        -- check if next tile is walkable
        if (nextCell == nil or not nextCell.walkable)
            return false

        -- moving
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

    die: =>

    currentCell: =>
        @scene.grid\cellAt(@currentGrid.x, @currentGrid.y)
