export class Grid extends Entity
    new: =>
        super!

        @layer = Settings.layers.entity.scenario
        @rows = 0
        @columns = 0
        @properties = {}
        @isLoaded = false

        -- cell
        @cell = width: 0, height: 0
        @cells = {}
        @gridCellGraphic = love.graphics.newImage("#{Settings.folders.graphics}/cell.png")
        @gridCellQuad = love.graphics.newQuad(0, 0, 16, 16, @gridCellGraphic\getDimensions!)
        @cellsOpacity = 0.0

        @opacityTweenDir = 0
        @opacityTween = nil

        -- layers
        @tilesets = {}
        @layers = {}

        -- entities
        -- for reference only
        @things = {
            enemies: {}
            pickups: {}
        }


    update: (dt) =>
        super(dt)

        -- cells
        if (@opacityTween != nil)
            complete = @opacityTween\update(dt)
            if (complete)
                @opacityTween = nil
                @opacityTweenDir = 0


    draw: =>
        super!
        if (@rows == 0 or @columns == 0)
            return

        -- layers
        for i, layer in pairs @layers
            layer\draw(@x, @y)

        -- cells
        love.graphics.setColor(1, 1, 1, @cellsOpacity)

        for y = 1, @rows
            for x = 1, @columns
                cell = @cellAt(x, y)
                if (not cell.walkable)
                    continue

                pos =
                    x: (x - 1) * @cell.width
                    y: (y - 1) * @cell.height

                -- prepare grid cell quad
                eastCell = @cellAt(x + 1, y)
                southCell = @cellAt(x, y + 1)
                if (eastCell == nil or not eastCell.walkable)
                    if (southCell == nil or not southCell.walkable)
                        --
                        @gridCellQuad\setViewport(48, 0, @cell.width, @cell.height)
                    else
                        -- South
                        @gridCellQuad\setViewport(32, 0, @cell.width, @cell.height)
                else
                    if (southCell == nil or not southCell.walkable)
                        -- East
                        @gridCellQuad\setViewport(16, 0, @cell.width, @cell.height)
                    else
                        -- East South
                        @gridCellQuad\setViewport(0, 0, @cell.width, @cell.height)

                love.graphics.draw(@gridCellGraphic, @gridCellQuad, @x + pos.x, @y + pos.y)

                -- give a chance to anything draw on grid (example: markers)
                if (cell.thing != nil and cell.thing.gridDraw != nil)
                    cell.thing\gridDraw(@x, @y, @cellsOpacity)


        love.graphics.setColor(1, 1, 1, 1)


    setup: (columns, rows) =>
        Lume.clear(@cells)
        @columns = columns
        @rows = rows
        for y = 1, @rows
            @cells[y] = {}
            for x = 1, @columns
                @cells[y][x] = GridCell!

    load: (mapFilename) =>
        @clear!

        @_file = require mapFilename
        @cell.width = @_file.tilewidth
        @cell.height = @_file.tilewidth
        @setup(@_file.width, @_file.height)

        -- centralize grid
        size =
            width: @cell.width * @columns
            height: @cell.height * @rows

        @x = Settings.screenCenter.x - size.width / 2
        @y = Settings.screenCenter.y - size.height / 2

        -- properties
        @properties = Lume.clone(@_file.properties)

        -- tilesets
        @tilesets = {}

        for i, t in pairs(@_file.tilesets)
            t.tilecount = columns: math.floor(t.imagewidth / t.tilewidth), height: math.floor(t.imageheight / t.tileheight)
            t.texture = love.graphics.newImage("#{Settings.folders.content}/#{string.sub(t.image, 4)}")
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

                    if (l.properties["collision"])
                        for y = 1, layer.rows
                            for x = 1, layer.columns
                                tile = layer.tiles[y][x]
                                @cells[y][x].walkable = (tile == nil)

                when "objectgroup"
                    for i, object in pairs l.objects
                        if (not object.visible)
                            continue

                        entity = nil
                        isEnemy = false
                        alreadyAdded = false
                        switch string.lower(object.type)
                            when "player"
                                if (@scene.player == nil)
                                    entity = Player!
                                    @scene.player = entity
                                else
                                    entity = @scene.player
                                    alreadyAdded = true

                                TurnBasedManager.instance.turns[Settings.turns.player.id]\register(entity)
                                print "added Player"
                            when "alien"
                                entity = AlienEnemy!
                                isEnemy = true
                                print "added AlienEnemy"
                            when "flower"
                                entity = FlowerEnemy!
                                isEnemy = true
                                print "added FlowerEnemy"
                            when "bat"
                                entity = BatEnemy!
                                isEnemy = true
                                print "added BatEnemy"
                            else
                                print "Unhandled object with type '#{object.type}' (at x: #{object.x}, y: #{object.y})."
                                continue

                        if (isEnemy)
                            Lume.push(@things.enemies, entity)
                            TurnBasedManager.instance.turns[Settings.turns.enemies.id]\register(entity)

                        entity.x = @x + object.x + math.floor(object.width / 2)
                        entity.y = @y + object.y + math.floor(object.height / 2)
                        --entity.visile = object.visible
                        if (not alreadyAdded)
                            @scene\addEntity(entity)
                else
                    print "Undefined grid layer type '#{l.type}'."
                    continue

        @isLoaded = true

    clear: =>
        Lume.clear(@properties)

        for k, v in pairs @things
            Lume.clear(v)

        Lume.clear(@layers)

    cellAt: (gridX, gridY) =>
        if (@cells[gridY] == nil)
            return nil

        @cells[gridY][gridX]

    transformToGridPos: (x, y) =>
        math.floor((x - @x) / @cell.width) + 1, math.floor((y - @y) / @cell.height) + 1

    transformToPos: (gridX, gridY) =>
        @x + (gridX - 1) * @cell.width, @y + (gridY - 1) * @cell.height

    hide: =>
        if (@opacityTweenDir == -1)
            return

        @opacityTween = Tween.new(.8, @, { cellsOpacity: 0.0 }, "outCubic")
        @opacityTweenDir = -1

    show: =>
        if (@opacityTweenDir == 1)
            return

        @opacityTween = Tween.new(.8, @, { cellsOpacity: 1.0 }, "inCubic")
        @opacityTweenDir = 1

    toggle: =>
        if (@opacityTweenDir <= 0)
            @show!
        elseif (@opacityTweenDir > 0)
            @hide!
