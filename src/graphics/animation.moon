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
        @currentTrackLabel = ""
        @isPlaying = false

    update: (dt) =>
        super(dt)
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

        @currentTrackLabel = label
        @currentTrack = @tracks[label]
        if (forceReset)
            @currentTrack\reset!

        @_updateFrame!
        @isPlaying = true

    _updateFrame: =>
        id = @currentTrack.currentFrame.id
        fX = id % @frameCount.columns
        fY = math.floor(id / @frameCount.columns)
        @quad\setViewport(fX * @frame.width, fY * @frame.height, @frame.width, @frame.height)
