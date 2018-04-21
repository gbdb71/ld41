export class Actor extends Entity
    new: =>
        super!
        @movement = nil
        @isMoving = false
        @moveDirection = x: 0, y: 0

    beforeUpdate: =>
        super!

    update: (dt) =>
        super(dt)
        if (@isMoving and not @movement.hasTargetPosition)
            @isMoving = false
            @moveDirection.x = 0
            @moveDirection.y = 0


    draw: =>
        super!
        --love.graphics.rectangle("fill", @movement.targetPosition.x, @movement.targetPosition.y, 1, 1)


    move: (x, y) =>
        if (@isMoving)
            return

        @isMoving = true
        @moveDirection.x = x
        @moveDirection.y = y
        @movement\moveTo(@x + @moveDirection.x * Settings.tileSize.width, @y + @moveDirection.y * Settings.tileSize.height)

    moveUp: (tiles=1) =>
        @move(0, -tiles)

    moveRight: (tiles=1) =>
        @move(tiles, 0)

    moveDown: (tiles=1) =>
        @move(0, tiles)

    moveLeft: (tiles=1) =>
        @move(-tiles, 0)

    die: =>
