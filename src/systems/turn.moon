export class Turn
    new: (active=false) =>
        @name = "Turn"
        @id = -1
        @active = active
        @things = {}

        -- callbacks
        @callbacks = {
            onStartTurn: (turn) -> return turn.id
            onEndTurn: (turn) -> return turn.id
        }


    update: (dt) =>
        for _, thing in ipairs @things
            thing\updateTurn(dt, @)
            

    startTurn: =>
        for _, thing in ipairs @things
            thing.hasEndedTurn = false
            thing\startTurn(@)

        @callbacks.onStartTurn(@)

    endTurn: =>
        @callbacks.onEndTurn(@)
        for _, thing in ipairs @things
            thing\endTurn(@)

    hasEnded: =>
        for _, thing in ipairs @things
            if (not thing.hasEndedTurn)
                return false

        return true

    register: (thing) =>
        Lume.push(@things, thing)

    clear: =>
        Lume.clear(@things)

    toString: =>
        "Turn | id: #{@id}, name: #{@name}, active? #{@active}, things: #{#@things}"
