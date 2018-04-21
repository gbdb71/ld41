export class Entity
    new: =>
        @x = 0
        @y = 0
        @scene = nil
        @graphic = nil

    sceneAdded: (scene) =>
        @scene = scene

    sceneRemoved: =>
        @scene = nil

    sceneEnter: =>

    sceneLeave: =>

    beforeUpdate: =>

    update: (dt) =>

    lateUpdate: =>

    draw: =>
        if (@graphic != nil)
            @graphic\draw(@x, @y)
