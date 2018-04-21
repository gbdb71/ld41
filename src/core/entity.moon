export class Entity
    new: =>
        @x = 0
        @y = 0
        @visible = true
        @active = true
        @scene = nil
        @graphic = nil
        @components = Locker!

    sceneAdded: (scene) =>
        @scene = scene
        for _, component in ipairs @components.values
            component\added(@)

    sceneRemoved: =>
        @scene = nil
        for _, component in ipairs @components.values
            component\removed!

    sceneEnter: =>

    sceneLeave: =>


    beforeUpdate: =>
        for _, component in ipairs @components.values
            component\beforeUpdate!

    update: (dt) =>
        for _, component in ipairs @components.values
            component\update(dt)

    lateUpdate: =>
        for _, component in ipairs @components.values
            component\lateUpdate!


    draw: =>
        if (@graphic != nil)
            @graphic\draw(@x, @y)

        for _, component in ipairs @components.values
            component\draw!


    addComponent: (component) =>
        @components\add(component)
        if (@scene != nil)
            component\added(@)

        return component

    removeComponent: (component) =>
        if (@components\remove(component))
            component\removed(@)
