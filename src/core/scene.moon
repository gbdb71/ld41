export class Scene
    new: =>
        @graphics = Locker!
        @entities = Locker!

    enter: =>
        for i, entity in ipairs @entities.values
            entity\sceneEnter!

    leave: =>
        for i, entity in ipairs @entities.values
            entity\sceneLeave!

    beforeUpdate: =>
        @entities\keep!

        for i, entity in ipairs @entities.values
            entity\beforeUpdate!

    update: (dt) =>
        for i, entity in ipairs @entities.values
            entity\update(dt)

    lateUpdate: =>
        for i, entity in ipairs @entities.values
            entity\lateUpdate!

    draw: =>
        --for i, graphic in ipairs @graphics.values
        --    graphic\draw!

        for i, entity in ipairs @entities.values
            entity\draw!

    addEntity: (entity) =>
        @entities\add(entity)
