export class Game
    @instance: nil

    new: =>
        @@instance = @
        @startScene = EmptyScene!
        @scene = @startScene
        @nextScene = nil
        @scenes = {}

    start: (sceneLabel) =>
        @startScene = @getScene(sceneLabel)
        @nextScene = @startScene
        @_updateScene!

    update: (dt) =>
        @_updateScene!
        @scene\update(dt)

    draw: =>
        @scene\draw!

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
