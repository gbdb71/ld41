export class Grid extends Entity
    new: =>
        super!

        @rows = 0
        @columns = 0

        -- cell
        @cell = width: 0, height: 0
        @cells = {}
        @gridCellGraphic = love.graphics.newImage("content/graphics/cell.png")
        @gridCellQuad = love.graphics.newQuad(0, 0, 16, 16, @gridCellGraphic\getDimensions!)
        @emptyTile = GridTile!

        -- layers
        @tilesets = {}
        @layers = {}

    update: (dt) =>
        super(dt)

    draw: =>
        super!
        if (@rows == 0 or @columns == 0)
            return

        -- layers
        for i, layer in pairs @layers
            layer\draw!

        -- cells
        love.graphics.setColor(0, 0, 0, 0)
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

        love.graphics.setColor(255, 255, 255, 255)

    setup: (columns, rows) =>
        Lume.clear(@cells)
        @columns = columns
        @rows = rows
        for y = 1, @rows
            @cells[y] = {}
            for x = 1, @columns
                @cells[y][x] = @emptyTile

    load: (mapFilename) =>
        @clear!

        @_file = require mapFilename
        @cell.width = @_file.tilewidth
        @cell.height = @_file.tilewidth
        @setup(@_file.width, @_file.height)

        -- tilesets
        @tilesets = {}

        for i, t in pairs(@_file.tilesets)
            t.tilecount = columns: math.floor(t.imagewidth / t.tilewidth), height: math.floor(t.imageheight / t.tileheight)
            t.texture = love.graphics.newImage("content/#{string.sub(t.image, 4)}")
            @tilesets[t.firstgid] = t


        -- layers
        tileset = @tilesets[1]
        for i, l in pairs(@_file.layers)
            switch l.type
                when "tilelayer"
                    layer = GridTileLayer(l.width, l.height)
                    layer.name = l.name
                    layer.visible = l.visible
                    layer\load(l.data, tileset)

                    Lume.push(@layers, layer)
                else
                    print "Undefined grid layer type '#{l.type}'."

    clear: =>
        Lume.clear(@layers)
