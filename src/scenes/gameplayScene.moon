export class GameplayScene extends Scene
    new: =>
        super!

        -- grid
        require "world/grid/gridTile"
        require "world/grid/grid"
        with @grid = Grid(Settings.tileSize.width, Settings.tileSize.height)
            \setup(10, 10)

        @addEntity(@grid)

        -- actors
        require "things/actors/actor"

        -- player
        require "things/actors/player/player"
        @player = Player!
        @addEntity(@player)

    enter: =>
        super!

    leave: =>
        super!


    beforeUpdate: =>
        super!
        keyboard = Settings.input.keyboard
        if (love.keyboard.isDown(keyboard["movement"].up))
            @player\moveUp!
        else if (love.keyboard.isDown(keyboard["movement"].down))
            @player\moveDown!

        if (love.keyboard.isDown(keyboard["movement"].left))
            @player\moveLeft!
        else if (love.keyboard.isDown(keyboard["movement"].right))
            @player\moveRight!

    update: (dt) =>
        super(dt)


    draw: =>
        super!
        love.graphics.print(@player.movement\toString!, 10, 10)
