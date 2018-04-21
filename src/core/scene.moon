export class Scene
    new: =>
        @graphics = Locker!
        @entities = Locker!

    enter: =>
        for _, entity in ipairs @entities.values
            entity\sceneEnter!

    leave: =>
        for _, entity in ipairs @entities.values
            entity\sceneLeave!


    beforeUpdate: =>
        @entities\keep!

        for _, entity in ipairs @entities.values
            entity\beforeUpdate!

    update: (dt) =>
        for _, entity in ipairs @entities.values
            entity\update(dt)

    lateUpdate: =>
        for _, entity in ipairs @entities.values
            entity\lateUpdate!


    draw: =>
        --for _, graphic in ipairs @graphics.values
        --    graphic\draw!

        for _, entity in ipairs @entities.values
            entity\draw!
            

    addEntity: (entity) =>
        @entities\add(entity)
        entity\sceneAdded(@)

    removeEntity: (entity) =>
        if (@entities\remove(entity))
            entity\sceneRemoved!
