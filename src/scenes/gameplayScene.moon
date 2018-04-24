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
        require "things/actors/enemies/seedBullet"

        if (Enemy.attackRangeMarker == nil)
            Enemy.attackRangeMarker = Image("#{Settings.folders.graphics}/enemy_range.png")

        -- pickups
        require "things/pickups/pickup"
        require "things/pickups/gem"
        require "things/pickups/heart"

        -- others
        require "things/others/chest"

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
                print @toString!
                print @turnManager\toString!

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

        -- rooms
        @canChangeRoom = true
        @hasRoomEnded = false
        @changeRoomTimer = 0

        -- ui
        require "systems/ui"
        @ui = UI!

        -- room transition
        @playingRoomTransition = false
        @roomTransitionHasEnded = false
        with @roomTransitionInGraphic = ImageSet("#{Settings.folders.graphics}/room_transition_in.png", 320, 180)
            .frameDuration = .060
            .callbacks.onEnd = ->
                @roomTransitionHasEnded = true
                print "in end"

            \play!

        with @roomTransitionOutGraphic = ImageSet("#{Settings.folders.graphics}/room_transition_out.png", 320, 180)
            .frameDuration = .060
            .callbacks.onEnd = ->
                @roomTransitionHasEnded = true
                @playingRoomTransition = false
                print "out end"
                @startRoom!

            \play!

        @roomTransitionGraphic = @roomTransitionInGraphic

        -- title
        with @title = Image("#{Settings.folders.graphics}/title.png")
            .origin.x = 90
            .origin.y = 46
            .x = Settings.screenCenter.x
            .y = -100

        with @moveHelper = Image("#{Settings.folders.graphics}/move_helper.png")
            .origin.x = 40
            .origin.y = 13
            .x = Settings.screenCenter.x
            .y = Settings.screenSize.height + 30

        @playingTitleTween = false
        @titleTween = Tween.new(1, @title, { y: Settings.screenCenter.y - 32 }, "outCubic")
        @moveHelperTween = Tween.new(1, @moveHelper, { y: Settings.screenSize.height - 30 }, "outCubic")
        @titleTweenDir = 1

        -- game ends
        @playingGameEnd = false
        @playingGameEndType = "bad"
        @gameEndId = 0

        -- bad
        with @badEndBackground = Image("#{Settings.folders.graphics}/defeat_screen.png")
            .opacity = 0

        @badEndScreenOpacity = 0.0
        @badEndOpacityTween = Tween.new(4, @, { badEndScreenOpacity: 1.0 }, "outQuad")
        @badEndBackgroundTween = Tween.new(2, @badEndBackground, { opacity: 1.0 }, "inQuad")
        @badEndPlayerTween = nil

        -- victory
        with @victoryEndCredits = Image("#{Settings.folders.graphics}/credits.png")
            .origin.x = 100
            .origin.y = 39
            .x = Settings.screenCenter.x
            .y = 64
            .opacity = 0.0

        @victoryEndOpacityTween = Tween.new(4, @victoryEndCredits, { opacity: 1.0 }, "outQuad")

        @clock = 0

    enter: =>
        super!

        @addEntity(@grid)
        @addEntity(@ui)

        @clock = 0

        -- room transition
        @playingRoomTransition = false
        @roomTransitionHasEnded = false

        -- game ends
        @playingGameEnd = false
        @playingGameEndType = "bad"
        @gameEndId = 0

        @titleTweenDir = 1
        Settings.audio.content.music["theme"]\play!
        @playingTitleTween = true

        -- first grid load
        if (not @grid.isLoaded)
            @prepareRoom("start")
            @startRoom!
            @ui.maxHearts = @player.maxHealth
            @ui\setHeart(@player.maxHealth)

    leave: =>
        super!
        Settings.audio.content.music["theme"]\stop!
        @clearRoom!
        @grid.isLoaded = false
        @entities\clear!


    beforeUpdate: =>
        super!
        if (not @turnManager.hasStarted or not @turnManager.isPlaying)
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
            else if (love.keyboard.isDown(keyboard["movement"].right[1]) or love.keyboard.isDown(keyboard["movement"].right[2]))
                move.x = 1

            if (move.x != 0 or move.y != 0)
                if (@playingTitleTween)
                    @titleTweenDir = -1

                @player\move(move.x, move.y)

    update: (dt) =>
        @clock += dt
        if (@playingTitleTween)
            @moveHelperTween\update(dt * @titleTweenDir)
            if (not @titleTween\update(dt * @titleTweenDir) and @titleTween.clock <= 0)
                @playingTitleTween = false

        if (@playingRoomTransition)
            super(dt)
            @roomTransitionGraphic\update(dt)
            if (@roomTransitionHasEnded)
                if (@roomTransitionGraphic == @roomTransitionInGraphic)
                    @roomTransitionGraphic = @roomTransitionOutGraphic

                    -- game end
                    if (@playingGameEnd)
                        @playingGameEnd = false
                        switch (@playingGameEndType)
                            when "bad"
                                Settings.audio.content.music["theme"]\play!
                                @badEndOpacityTween\reset!
                                @badEndBackgroundTween\reset!
                                --@badEndScreenOpacity = 0
                            when "good"
                                @victoryEndOpacityTween\reset!

                        @player\removeSelf!
                        @player = nil
                        @prepareRoom("start")
                        @ui.maxHearts = @player.maxHealth
                        @ui\setHeart(@player.maxHealth)
                    else
                        @prepareRoom!
                else
                    @roomTransitionHasEnded = false

        if (@playingGameEnd)
            super(dt)
            switch (@playingGameEndType)
                when "bad"
                    if (@gameEndId == 0)
                        @badEndOpacityTween\update(dt)
                        if (@badEndPlayerTween\update(dt))
                            @gameEndId = 1
                    elseif (@gameEndId == 1)
                        if (@badEndBackgroundTween\update(dt))
                            @gameEndId = 2
                    elseif (@gameEndId == 2)
                        confirm = false
                        if (love.keyboard.isDown("return", "z", "x"))
                            confirm = true
                        else
                            for action, keys in pairs Settings.input.keyboard.movement
                                for _, key in ipairs keys
                                    if (love.keyboard.isDown(key))
                                        confirm = true
                                        break

                                if (confirm)
                                    break

                        if (confirm)
                            @resetGame!
                            @gameEndId = 3

                when "good"
                    if (@gameEndId == 0)
                        if (@victoryEndOpacityTween\update(dt))
                            @gameEndId = 1
                    elseif (@gameEndId == 1)
                        confirm = false
                        if (love.keyboard.isDown("return", "z", "x"))
                            confirm = true
                        else
                            for action, keys in pairs Settings.input.keyboard.movement
                                for _, key in ipairs keys
                                    if (love.keyboard.isDown(key))
                                        confirm = true
                                        break

                                if (confirm)
                                    break

                        if (confirm)
                            @resetGame!
                            @gameEndId = 2


        else
            @turnManager\update(dt)
            super(dt)
            @announcer\update(dt)

    lateUpdate: =>
        super!

        if (@playingGameEnd)
            return

        if (@playingRoomTransition)
            return

        -- UI
        @ui\setHeart(@player.health)
        @ui\setGem(@player.gems)

        -- turn manager
        @turnManager\lateUpdate!

        -- room change
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
                @turnManager\pause!
                @roomTransitionGraphic = @roomTransitionInGraphic
                @playingRoomTransition = true
                @roomTransitionHasEnded = false
                @canChangeRoom = false

    draw: =>
        super!

        if (@playingRoomTransition)
            @roomTransitionGraphic\draw!

        if (@playingGameEnd)
            switch (@playingGameEndType)
                when "bad"
                    -- bg
                    love.graphics.setColor(Settings.backgroundColor[1], Settings.backgroundColor[2], Settings.backgroundColor[3], @badEndScreenOpacity)
                    love.graphics.rectangle("fill", 0, 0, Settings.screenSize.width, Settings.screenSize.height)
                    love.graphics.setColor(1, 1, 1, 1)

                    -- bg image
                    @badEndBackground\draw!

                    -- player
                    @player\draw!
                when "good"
                    @victoryEndCredits\draw!

            return

        @announcer\draw!

        if (@playingTitleTween)
            @title\draw!
            @moveHelper\draw!

        --love.graphics.print(@player.movement\toString!, 10, 10)

    clearRoom: =>
        -- remove all entities, added by grid, from the scene
        for key, entityList in pairs @grid.things
            for _, entity in ipairs entityList
                @removeEntity(entity)

        @turnManager\reset!

    prepareRoom: (roomFilename) =>
        nextRoomFilename = roomFilename or @grid.properties["nextRoom"]
        if (nextRoomFilename == nil)
            @canChangeRoom = false
            return

        @clearRoom!
        @grid\load("#{Settings.folders.maps}/#{nextRoomFilename}")


    startRoom: =>
        @turnManager\start!
        @canChangeRoom = true
        @hasRoomEnded = false
        @changeRoomTimer = 0

        -- debug
        print @toString!
        print @turnManager\toString!

    callBadEnd: =>
        Settings.audio.content.music["theme"]\stop!
        @playingGameEnd = true
        @turnManager\pause!
        @canChangeRoom = false
        @player.visible = false
        @playingGameEndType = "bad"
        finalPos = x: Settings.screenCenter.x, y: Settings.screenCenter.y
        @badEndPlayerTween = Tween.new(3, @player, { x: finalPos.x, y: finalPos.y }, "linear")
        @badEndBackground.opacity = 0
        @gameEndId = 0

    callGoodEnd: =>
        @playingGameEnd = true
        @turnManager\pause!
        @canChangeRoom = false
        @playingGameEndType = "good"
        @gameEndId = 0

    resetGame: =>
        switch (@playingGameEndType)
            when "bad"
                @roomTransitionGraphic = @roomTransitionInGraphic
                @playingRoomTransition = true
                @roomTransitionHasEnded = false

            when "good"
                @victoryEndOpacityTween\reset!
                @playingRoomTransition = true
                @roomTransitionHasEnded = false
                Game.instance\changeScene("intro")
