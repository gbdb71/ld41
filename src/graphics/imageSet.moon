export class ImageSet extends Image
    new: (filename, frameWidth, frameHeight) =>
        super(filename)
        @frame = width: frameWidth, height: frameHeight
        @quad = love.graphics.newQuad(0, 0, @frame.width, @frame.height, @texture\getDimensions!)
        @frameCount =
            columns: math.floor(@texture\getWidth! / @frame.width)
            rows: math.floor(@texture\getHeight! / @frame.height)

        @totalFrames = @frameCount.columns * @frameCount.rows

        @currentFrameId = 1
        @isLooping = false
        @isPlaying = false
        @clock = 0
        @frameDuration = 0

    update: (dt) =>
        super(dt)
        if (not @isPlaying)
            return false

        @clock += dt
        if (@clock >= @frameDuration)
            @clock = 0

            @currentFrameId += 1
            if (@currentFrameId > @totalFrames)
                if (@isLooping)
                    @currentFrameId = 1
                    return true
                else
                    @stop!
                    return true

            @_updateFrame!

        return false


    play: (forceReset=true) =>
        @isPlaying = true
        @currentFrameId = 1
        @clock = 0
        @_updateFrame!

    stop: =>
        @isPlaying = false

    _updateFrame: =>
        fX = @currentFrameId % @frameCount.columns
        fY = math.floor(@currentFrameId / @frameCount.columns)
        @quad\setViewport(fX * @frame.width, fY * @frame.height, @frame.width, @frame.height)
