export class GameplayScene extends Scene
    new: =>
        super!

        -- actors
        require "things/actors/actor"

        -- player
        require "things/actors/player/player"
        @player = nil

        -- announcer
        require "systems/announcer"
        @announcer = Announcer(Settings.screenCenter.x, -50)

        -- turn based manager
        require "systems/turn"
        require "systems/turnBasedManager"
        with @turnManager = TurnBasedManager!
            .turnChangeDelay = Settings.turnChangeDelay
            .callbacks.onStartRound = (round) ->
                @turnManager.canChangeTurn = false
                @announcer\play("Round #{round} started!", -> @turnManager.canChangeTurn = true)

            .callbacks.onEndRound = (round) ->
                @turnManager.canChangeRound = false
                @announcer\play("Round #{round} ended", -> @turnManager.canChangeRound = true)

        -- register all turn settings from Settings.turns (on settings.moon)
        for name, turnSettings in pairs Settings.turns
            with turn = @turnManager\addTurn(Turn!)
                .name = turnSettings.name
                .active = turnSettings.active
                .callbacks.onStartTurn = turnSettings.onStartTurn
                .callbacks.onEndTurn = turnSettings.onEndTurn

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
        print @toString!

        @turnManager\start!

        print @turnManager\toString!

    leave: =>
        super!


    beforeUpdate: =>
        super!
        if (not @turnManager.hasStarted)
            return

        if (not @player.isWaiting)
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

            if (move.x != 0 or move.y != 0)
                if (@player\move(move.x, move.y))
                    @player\finishTurn!

    update: (dt) =>
        @turnManager\update(dt)
        super(dt)
        @announcer\update(dt)

    lateUpdate: =>
        @turnManager\lateUpdate!


    draw: =>
        super!
        @announcer\draw!

        --love.graphics.print(@player.movement\toString!, 10, 10)
