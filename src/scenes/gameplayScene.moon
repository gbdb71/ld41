export class GameplayScene extends Scene
    new: =>
        super!

        -- actors
        require "things/actors/actor"

        -- enemies
        require "things/actors/enemies/enemy"
        require "things/actors/enemies/alienEnemy"
        require "things/actors/enemies/batEnemy"
        require "things/actors/enemies/flowerEnemy"

        if (Enemy.attackRangeMarker == nil)
            Enemy.attackRangeMarker = Image("#{Settings.folders.graphics}/enemy_range.png")

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
                print "start round #{round}"
                --@turnManager.canChangeTurn = false
                --@announcer\play("Round #{round} started!", -> @turnManager.canChangeTurn = true)

            .callbacks.onEndRound = (round) ->
                print "end round #{round}\n"
                --@turnManager.canChangeRound = false
                --@announcer\play("Round #{round} ended", -> @turnManager.canChangeRound = true)

            .callbacks.onStartTurn = (turn) ->
                @turnManager.currentTurn\play!
                --@announcer\play(turnSettings.messages.startTurn, -> @turnManager.currentTurn\play!)

        -- register all turn settings from Settings.turns (on settings.moon)
        for name, turnSettings in pairs Settings.turns
            with turn = @turnManager\addTurn(Turn!)
                .name = turnSettings.name
                .active = turnSettings.active

        with playerTurn = @turnManager.turns[Settings.turns.player.id]
            .callbacks.onStartTurn = (turn) ->
                @grid\show!

            .callbacks.onEndTurn = (turn) ->
                @grid\hide!

        -- grid
        require "world/grid/gridCell"
        require "world/grid/gridLayer"
        require "world/grid/gridTileLayer"
        require "world/grid/grid"
        @grid = Grid!
        @addEntity(@grid)

        -- rooms
        @canChangeRoom = true
        @hasRoomEnded = false
        @changeRoomTimer = 0

        -- ui
        require "systems/ui"
        @ui = UI!
        @addEntity(@ui)

        @clock = 0

    enter: =>
        super!

        -- first grid load
        if (not @grid.isLoaded)
            @nextRoom("test")
            @ui.maxHearts = @player.maxHealth
            @ui\setHeart(@player.maxHealth)

    leave: =>
        super!


    beforeUpdate: =>
        super!
        if (not @turnManager.hasStarted)
            return

        if (not @player.isWaiting)
            move = x: 0, y: 0
            keyboard = Settings.input.keyboard

            if (love.keyboard.isDown(keyboard["movement"].up[1]) or love.keyboard.isDown(keyboard["movement"].up[2]))
                move.y = -1
            else if (love.keyboard.isDown(keyboard["movement"].down[1]) or love.keyboard.isDown(keyboard["movement"].down[2]))
                move.y = 1

            else if (love.keyboard.isDown(keyboard["movement"].left[1]) or love.keyboard.isDown(keyboard["movement"].left[2]))
                move.x = -1
                @ui\addGem(100)
            else if (love.keyboard.isDown(keyboard["movement"].right[1]) or love.keyboard.isDown(keyboard["movement"].right[2]))
                move.x = 1
                @ui\addGem(500)

            if (move.x != 0 or move.y != 0)
                if (@player\move(move.x, move.y))
                    @player\finishTurn!

    update: (dt) =>
        @clock += dt
        @turnManager\update(dt)
        super(dt)
        @announcer\update(dt)

    lateUpdate: =>
        super!
        @turnManager\lateUpdate!

        if (@canChangeRoom)
            if (not @hasRoomEnded)
                someoneAlive = false
                for _, enemy in pairs @grid.things.enemies
                    if (enemy.isAlive)
                        someoneAlive = true
                        break

                if (not someoneAlive)
                    @hasRoomEnded = true
                    @changeRoomTimer = @clock + Settings.changeRoomDelay
            elseif (@clock >= @changeRoomTimer)
                @nextRoom!


    draw: =>
        super!
        @announcer\draw!

        --love.graphics.print(@player.movement\toString!, 10, 10)


    nextRoom: (roomFilename) =>
        nextRoomFilename = roomFilename or @grid.properties["nextRoom"]
        if (nextRoomFilename == nil)
            @canChangeRoom = false
            return

        if (@grid.isLoaded)
            -- remove all entities, added by grid, from the scene
            for key, entityList in pairs @grid.things
                for _, entity in ipairs entityList
                    @removeEntity(entity)


        @grid\load("#{Settings.folders.maps}/#{nextRoomFilename}")
        @turnManager\start!
        @canChangeRoom = true
        @hasRoomEnded = false
        @changeRoomTimer = 0

        -- debug
        print @toString!
        print @turnManager\toString!
