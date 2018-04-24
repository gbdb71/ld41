export class TurnBasedManager
    @instance = nil

    new: =>
        @@instance = @
        @hasStarted = false
        @isPlaying = false

        -- round
        @round = 1
        @isRoundEnded = true
        @canChangeRound = true

        -- turns
        @turns = {}
        @currentTurnId = 0
        @previousTurn = nil
        @currentTurn = nil
        @canChangeTurn = true

        -- turn transition
        @inTurnTransition = false

        -- turn change delay
        @turnChangeDelay = 0
        @turnChangeClock = 0

        -- callbacks
        @callbacks = {
            onStartRound: (round) -> return round
            onEndRound: (round) -> return round
            onStartTurn: (turn) -> return turn.id
            onEndTurn: (turn) -> return turn.id
        }


    update: (dt) =>
        if (not @hasStarted or not @isPlaying)
            return

        if (@currentTurn != nil)
            @currentTurn\update(dt)

        if (@inTurnTransition)
            @turnChangeClock = math.max(0, @turnChangeClock - dt)

            -- if can change turn
            if (@turnChangeClock <= 0)
                -- holds round change
                if (@isRoundEnded)
                    if (@canChangeRound)
                        @callbacks.onStartRound(@round)
                        @isRoundEnded = false
                    else
                        return

                -- holds turn change
                if (not @canChangeTurn)
                    return

                @turnChangeClock = 0
                @inTurnTransition = false

                @callbacks.onStartTurn(@currentTurn)
                @currentTurn\startTurn!

    lateUpdate: =>
        if (not @hasStarted or not @isPlaying)
            return

        if (@currentTurn.hasEnded)
            @nextTurn!


    start: (turn=1) =>
        @hasStarted = true
        @isPlaying = true
        @inTurnTransition = true
        @_updateCurrentTurn(turn)

    pause: =>
        @isPlaying = true

    resume: =>
        @isPlaying = false

    reset: =>
        @hasStarted = false

        -- round
        @round = 1
        @isRoundEnded = true
        @canChangeRound = true

        -- turns
        @currentTurnId = 0
        @previousTurn = nil
        @currentTurn = nil
        @canChangeTurn = true

        for _, turn in pairs @turns
            turn\clear!

        -- turn transition
        @inTurnTransition = false

        -- turn change delay
        @turnChangeClock = 0

    nextTurn: =>
        if (@inTurnTransition)
            return

        if (@turnChangeDelay > 0)
            @turnChangeClock = @turnChangeDelay

        @inTurnTransition = true
        @_updateCurrentTurn(@currentTurnId + 1)

    addTurn: (turn) =>
        Lume.push(@turns, turn)
        turn.id = #@turns
        return turn

    toString: =>
        str = "turns: #{#@turns}, current: #{@currentTurnId}, changeDelay: #{@turnChangeDelay}\n"
        for i, turn in ipairs @turns
            str ..= "  #{i}  #{turn\toString!}\n"

        return str


    _updateCurrentTurn: (turn) =>
        if (turn > #@turns)
            turn = 1

        @previousTurn = @currentTurn
        if (@previousTurn != nil)
            @callbacks.onEndTurn(@previousTurn)
            @previousTurn\endTurn!

            if (@previousTurn.id > turn)
                @callbacks.onEndRound(@round)
                @isRoundEnded = true
                @round += 1

        @currentTurnId = turn
        @currentTurn = @turns[@currentTurnId]
