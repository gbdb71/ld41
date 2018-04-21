export class Grid extends Entity
    new: (cellWidth, cellHeight) =>
        super!
        @rows = 0
        @columns = 0
        @cell = width: cellWidth, height: cellHeight
        @cells = {}
        @emptyTile = GridTile!

    update: (dt) =>
        super(dt)

    draw: =>
        super!
        for y = 1, @rows
            for x = 1, @columns
                pos = x: (x - 1) * @cell.width, y: (y - 1) * @cell.height
                @cells[y][x]\draw(pos.x, pos.y, @cell.width, @cell.height)

    setup: (columns, rows) =>
        Lume.clear(@cells)
        @columns = columns
        @rows = rows
        for y = 1, @rows
            @cells[y] = {}
            for x = 1, @columns
                @cells[y][x] = @emptyTile
