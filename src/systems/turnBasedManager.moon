export class TurnBasedManager
    @instance = nil

    new: =>
        @@instance = @
        @hasStarted = false

        -- round
        @round = 1

        -- turns
        @turns = {}
        @currentTurnId = 0
        @previousTurn = nil
        @currentTurn = nil

        -- turn transition
        @inTurnTransition = false

        -- turn change delay
        @turnChangeDelay = 0
        @turnChangeClock = 0

        -- callbacks
        @callbacks = {
            onStartRound: (round) -> return round
            onEndRound: (round) -> return round
        }


    update: (dt) =>
        if (not @hasStarted)
            return

        if (@currentTurn != nil)
            @currentTurn\update(dt)

        if (@inTurnTransition)
            @turnChangeClock -= dt
            if (@turnChangeClock <= 0)
                @turnChangeClock = 0
                @inTurnTransition = false

                if (@previousTurn == nil or (@previousTurn.id == #@turns and @currentTurn.id == 1))
                    @callbacks.onStartRound(@round)

                @currentTurn\startTurn!

    lateUpdate: =>
        if (not @hasStarted)
            return

        if (@currentTurn\hasEnded!)
            @nextTurn!

    start: (turn=1) =>
        @hasStarted = true
        @inTurnTransition = true
        @_updateCurrentTurn(turn)

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
            @previousTurn\endTurn!

            if (@previousTurn.id > turn)
                @callbacks.onEndRound(@round)
                @round += 1

        @currentTurnId = turn
        @currentTurn = @turns[@currentTurnId]
