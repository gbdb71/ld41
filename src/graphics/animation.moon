export class Animation extends Image
    new: (filename, frameWidth, frameHeight) =>
        super(filename)
        @frame = width: frameWidth, height: frameHeight
        @quad = love.graphics.newQuad(0, 0, @frame.width, @frame.height, @texture\getDimensions!)
        @frameCount =
            columns: math.floor(@texture\getWidth! / @frame.width)
            rows: math.floor(@texture\getHeight! / @frame.height)

        @tracks = {}
        @currentTrack = nil
        @isPlaying = false

    update: (dt) =>
        if (not @isPlaying or @currentTrack == nil)
            return

        changedFrame = @currentTrack\update(dt)
        if (changedFrame)
            @_updateFrame!

    addTrack: (label, frameIds, time) =>
        track = AnimationTrack(frameIds, time)
        @tracks[label] = track
        return track

    play: (label, forceReset=true) =>
        if (@tracks[label] == nil)
            error "Track with label '#{label}' not found."
            return

        @currentTrack = @tracks[label]
        @_updateFrame!
        @isPlaying = true

    _updateFrame: =>
        fX = @currentTrack.currentFrame.id % @frameCount.columns
        fY = math.floor(@currentTrack.currentFrame.id / @frameCount.columns)
        @quad\setViewport(fX * @frame.width, fY * @frame.height, @frame.width, @frame.height)