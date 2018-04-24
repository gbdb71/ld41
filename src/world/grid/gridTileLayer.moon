export class GridTileLayer extends GridLayer
    @flippedHorizontallyFlag = 0x80000000
    @flippedVerticallyFlag = 0x40000000
    @flippedDiagonallyFlag = 0x20000000

    new: (columns, rows) =>
        @name = "GridTileLayer"
        @visible = true
        @x = 0
        @y = 0
        @tiles = {}
        @cell = width: 0, height: 0
        @setup(columns, rows)


    draw: (topLeftX, topLeftY) =>
        super!
        for y = 1, @rows
            for x = 1, @columns
                tile = @tiles[y][x]
                if (tile == nil)
                    continue

                -- 1  2
                -- 3  4

                -- d
                -- 4  2
                -- 3  1
                -- r = 90
                -- sy = -1

                -- h v
                -- 2  1 -> 4  3
                -- 4  3 -> 2  1
                -- sx = sy = -1

                -- h d
                -- 4  2 -> 2  4
                -- 3  1 -> 1  3
                -- r = 90

                -- v d
                -- 4  2 -> 3  1
                -- 3  1 -> 4  2
                -- r = 90

                -- h v d
                -- 4  2 -> 3  1 -> 1  3
                -- 3  1 -> 4  2 -> 2  4
                -- r = -90
                -- sy = -1

                --scale = x: 1, y: 1
                --rotation = 0
                --if (tile.reflect.d)
                 --   if (tile.reflect.h and tile.reflect.v)
                  --      rotation = math.rad(-90)
                   --     scale.y = -1
                    --elseif (tile.reflect.h)
                     --   rotation = math.rad(90)
                    --elseif (tile.reflect.v)
                        --rotation = math.rad(90)
                    --else
                        --rotation = math.rad(90)
                        --scale.y = -1
                --elseif (tile.reflect.h and tile.reflect.v)
                    --scale.x = -1
                    --scale.y = -1
                --elseif (tile.reflect.h)
                    --scale.x = -1
                --elseif (tile.reflect.v)
                    --scale.y = -1
                love.graphics.draw(
                    @texture
                    tile.quad
                    topLeftX + @x + x * @cell.width
                    topLeftY + @y + y * @cell.height
                )

                --love.graphics.draw(
                    --@texture
                    --tile.quad
                    --topLeftX + @x + (x - .5) * @cell.width
                    --topLeftY + @y + (y - .5) * @cell.height
                    --rotation
                    --scale.x, scale.y,
                    --@cell.width / 2, @cell.height / 2
                --)


    setup: (columns, rows) =>
        Lume.clear(@tiles)
        @columns = columns
        @rows = rows
        for y = 1, @rows
            @tiles[y] = {}
            for x = 1, @columns
                @tiles[y][x] = nil

    load: (csv, tileset) =>
        @cell = width: tileset.tilewidth, height: tileset.tileheight
        @texture = tileset.texture

        allFlags = bit.bor(bit.bor(@@flippedHorizontallyFlag, @@flippedVerticallyFlag), @@flippedDiagonallyFlag)

        x, y = 1, 1
        for i, gid in pairs(csv)
            if (gid > 0)
                reflect =
                    h: bit.band(gid, @@flippedHorizontallyFlag) != 0
                    v: bit.band(gid, @@flippedVerticallyFlag) != 0
                    d: bit.band(gid, @@flippedDiagonallyFlag) != 0

                gid = bit.band(gid, bit.bnot(allFlags))

                gid -= tileset.firstgid
                tx = gid % tileset.tilecount.columns
                ty = math.floor(gid / tileset.tilecount.columns)
                @tiles[y][x] =
                    quad: love.graphics.newQuad(tx * @cell.width, ty * @cell.height, tileset.tilewidth, tileset.tileheight, tileset.texture\getDimensions!)
                    reflect: {
                        h: reflect.h
                        v: reflect.v
                        d: reflect.d
                    }

            x += 1
            if (x > @columns)
                x = 1
                y += 1

    _findTileset: (tilesets, gid) =>
        for firstgid, tileset in pairs tilesets
            if (gid >= firstgid and gid <= firstgid + tileset.tilecount)
                return tileset

        return nil
