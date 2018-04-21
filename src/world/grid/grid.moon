export class Grid extends Entity
    new: (cellWidth, cellHeight) =>
        super!
        @rows = 0
        @columns = 0
        @cell = width: cellWidth, height: cellHeight
        @cells = {}
        @gridCellGraphic = love.graphics.newImage("content/graphics/cell.png")
        @gridCellQuad = love.graphics.newQuad(0, 0, 16, 16, @gridCellGraphic\getDimensions!)
        @emptyTile = GridTile!

    update: (dt) =>
        super(dt)

    draw: =>
        super!
        @gridCellQuad\setViewport(0, 0, @cell.width, @cell.height)
        for y = 1, @rows - 1
            for x = 1, @columns - 1
                pos = x: (x - 1) * @cell.width, y: (y - 1) * @cell.height
                love.graphics.draw(@gridCellGraphic, @gridCellQuad, pos.x, pos.y)

        @gridCellQuad\setViewport(16, 0, @cell.width, @cell.height)
        for x = 1, @columns - 1
            pos = x: (x - 1) * @cell.width, y: (@rows - 1) * @cell.height
            love.graphics.draw(@gridCellGraphic, @gridCellQuad, pos.x, pos.y)

        @gridCellQuad\setViewport(32, 0, @cell.width, @cell.height)
        for y = 1, @rows - 1
            pos = x: (@columns - 1) * @cell.width, y: (y - 1) * @cell.height
            love.graphics.draw(@gridCellGraphic, @gridCellQuad, pos.x, pos.y)

        @gridCellQuad\setViewport(48, 0, @cell.width, @cell.height)
        pos = x: (@columns - 1) * @cell.width, y: (@rows - 1) * @cell.height
        love.graphics.draw(@gridCellGraphic, @gridCellQuad, pos.x, pos.y)


    setup: (columns, rows) =>
        Lume.clear(@cells)
        @columns = columns
        @rows = rows
        for y = 1, @rows
            @cells[y] = {}
            for x = 1, @columns
                @cells[y][x] = @emptyTile
