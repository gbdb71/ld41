export class AnimationTrack
    new: (frameIds, time) =>
        @hasEnded = false
        @isLooping = false
        @clock = 0
        @frames = {}

        -- parse frame ids
        startRange = -1
        for id, rangeDelim in string.gmatch(frameIds, "(%d+)([-]?)")
            id = tonumber(id) - 1
            if (startRange != -1)
                for i = startRange, id
                    Lume.push(@frames, { id: i, time: 0 })

                startRange = -1
                continue

            if (rangeDelim != nil)
                startRange = id
                continue

            Lume.push(@frames, { id: id, time: 0 })

        -- parse frame time
        switch (type(time))
            when "table"
                id = 1
                for frameTime in string.gmatch(frameIds, "(%d+)")
                    @frames[id].time = tonumber(frameTime) / 1000.0
                    id += 1

            when "number"
                for id = 1, #@frames
                    @frames[id].time = time / 1000.0

            else
                error "Unexpected AnimationTrack time format"

        @currentId = 1
        @currentFrame = @frames[@currentId]

        -- callbacks
        @callbacks = {
            onEnd: -> return
        }

    update: (dt) =>
        if (@hasEnded)
            return

        @clock += dt
        if (@clock >= @currentFrame.time)
            @currentId += 1
            @clock = 0

            if (@currentId > #@frames)
                @callbacks.onEnd!
                if (@isLooping)
                    @currentId = 1
                else
                    @currentId = #@frames
                    @hasEnded = true
                    return false

            @currentFrame = @frames[@currentId]
            return true

        return false

    reset: =>
        @hasEnded = false
        @clock = 0
        @currentId = 1
        @currentFrame = @frames[@currentId]

    loop: (looping=true) =>
        @isLooping = looping
        return @

    onEnd: (onEndCallback) =>
        @callbacks.onEnd = onEndCallback
        return @
