export class Game
    @instance: nil

    new: =>
        @@instance = @

        -- scenes
        @startScene = EmptyScene!
        @scene = @startScene
        @nextScene = nil
        @scenes = {}

        -- input
        love.keyboard.setKeyRepeat true

        -- graphics
        @backgroundColor = Colors.Black
        @pixelScale = 1

        -- canvas
        love.graphics.setDefaultFilter("nearest", "nearest")
        @mainCanvas = love.graphics.newCanvas(Settings.screen_size.width, Settings.screen_size.height)
        @mainCanvas\setFilter("nearest", "nearest")


    start: (sceneLabel) =>
        @startScene = @getScene(sceneLabel)
        @nextScene = @startScene
        @_updateScene!

    update: (dt) =>
        @_updateScene!
        @scene\beforeUpdate!
        @scene\update(dt)
        @scene\lateUpdate!

    draw: =>
        love.graphics.setCanvas(@mainCanvas)
        love.graphics.setColor(@backgroundColor)
        love.graphics.rectangle("fill", 0, 0, @mainCanvas\getWidth!, @mainCanvas\getHeight!)
        love.graphics.setColor(Colors.White)

        @scene\draw!

        love.graphics.setCanvas!
        love.graphics.setColor(Colors.White)
        love.graphics.draw(@mainCanvas, 0, 0, 0, @pixelScale)

    addScene: (label, scene) =>
        if (@existsScene(label))
            error "Scene with label '#{label}' already exists."
            return

        @scenes[label] = scene

    getScene: (label) =>
        if (not @existsScene(label))
            error "Scene with label '#{label}' doesn't found."
            return

        @scenes[label]

    existsScene: (label) =>
        @scenes[label] != nil

    _updateScene: =>
        if (@nextScene == nil)
            return

        if (@scene != nil)
            @scene\leave!

        @scene = @nextScene
        @nextScene = nil
        @scene\enter!

    @changeScene: (label) =>
        if (@@instance\existsScene(label))
            error "Scene with label '#{label}' doesn't exists."
            return

        @@instance.nextScene = @@instance\getScene(label)
