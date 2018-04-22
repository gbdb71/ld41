export class GameplayScene extends Scene
    new: =>
        super!

        -- actors
        require "things/actors/actor"

        -- player
        require "things/actors/player/player"
        @player = nil

        -- grid
        require "world/grid/gridCell"
        require "world/grid/gridLayer"
        require "world/grid/gridTileLayer"
        require "world/grid/grid"
        @grid = Grid!
        @addEntity(@grid)

    enter: =>
        super!
        @grid\load("#{Settings.folders.maps}/test")

    leave: =>
        super!


    beforeUpdate: =>
        super!

        move = x: 0, y: 0
        keyboard = Settings.input.keyboard

        if (love.keyboard.isDown(keyboard["movement"].up))
            move.y = -1
        else if (love.keyboard.isDown(keyboard["movement"].down))
            move.y = 1

        if (love.keyboard.isDown(keyboard["movement"].left))
            move.x = -1
        else if (love.keyboard.isDown(keyboard["movement"].right))
            move.x = 1

        playerGridX, playerGridY = @grid\transformToGridPos(@player.x, @player.y)
        currentCell = @grid\cellAt(playerGridX, playerGridY)

        -- check if player current tile isn't walkable (impossible situation, but player dies)
        if (currentCell != nil and not currentCell.walkable)
            @player\die!

        if (move.x != 0 or move.y != 0)
            playerNextGridX = playerGridX + move.x
            playerNextGridY = playerGridY + move.y
            nextCell = @grid\cellAt(playerNextGridX, playerNextGridY)

            -- check if player next tile is walkable
            if (nextCell != nil and nextCell.walkable)
                @player\move(move.x, move.y)

    update: (dt) =>
        super(dt)


    draw: =>
        super!
        --love.graphics.print(@player.movement\toString!, 10, 10)
