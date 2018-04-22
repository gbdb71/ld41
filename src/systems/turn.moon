export class Turn
    new: (active=false) =>
        @name = "Turn"
        @id = -1
        @active = active
        @things = {}
        @isPlaying = false

        -- callbacks
        @callbacks = {
            onStartTurn: (turn) -> return turn.id
            onEndTurn: (turn) -> return turn.id
        }


    update: (dt) =>
        if (not @isPlaying)
            return

        for _, thing in ipairs @things
            thing\updateTurn(dt, @)

        -- check if turn has ended
        turnEnded = true
        for _, thing in ipairs @things
            if (not thing.hasEndedTurn)
                turnEnded = false
                break

        @isPlaying = (not turnEnded)

    startTurn: =>
        @isPlaying = true
        @callbacks.onStartTurn(@)
        for _, thing in ipairs @things
            thing.hasEndedTurn = false
            thing\startTurn(@)

    endTurn: =>
        @isPlaying = false
        @callbacks.onEndTurn(@)
        for _, thing in ipairs @things
            thing\endTurn(@)

    register: (thing) =>
        Lume.push(@things, thing)

    clear: =>
        Lume.clear(@things)

    toString: =>
        "Turn | id: #{@id}, name: #{@name}, active? #{@active}, things: #{#@things}"
