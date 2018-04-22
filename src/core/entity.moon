export class Entity
    new: =>
        @x = 0
        @y = 0
        @layer = 0
        @visible = true
        @active = true
        @scene = nil
        @graphic = nil
        @components = Locker!


    sceneAdded: (scene) =>
        @scene = scene
        @components\lock!
        for _, component in ipairs @components.values
            component\added(@)

        @components\unlock!

    sceneRemoved: =>
        @scene = nil
        @components\lock!
        for _, component in ipairs @components.values
            component\removed!

        @components\unlock!

    sceneEnter: =>

    sceneLeave: =>


    beforeUpdate: =>
        @components\lock!
        for _, component in ipairs @components.values
            component\beforeUpdate!

        @components\unlock!

    update: (dt) =>
        if (@graphic != nil)
            @graphic\update(dt)

        @components\lock!
        for _, component in ipairs @components.values
            component\update(dt)

        @components\unlock!

    lateUpdate: =>
        @components\lock!
        for _, component in ipairs @components.values
            component\lateUpdate!

        @components\unlock!


    draw: =>
        if (@graphic != nil)
            @graphic\draw(@x, @y)

        @components\lock!
        for _, component in ipairs @components.values
            component\draw!

        @components\unlock!


    addComponent: (component) =>
        @components\add(component)
        if (@scene != nil)
            component\added(@)

        return component

    removeComponent: (component) =>
        if (@components\remove(component))
            component\removed(@)

    removeSelf: =>
        @scene\removeEntity(@)
