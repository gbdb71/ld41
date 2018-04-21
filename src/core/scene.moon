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
            if (not entity.active)
                continue

            entity\beforeUpdate!

    update: (dt) =>
        for _, entity in ipairs @entities.values
            if (not entity.active)
                continue

            entity\update(dt)

    lateUpdate: =>
        for _, entity in ipairs @entities.values
            if (not entity.active)
                continue

            entity\lateUpdate!


    draw: =>
        --for _, graphic in ipairs @graphics.values
            --if (not graphic.visible)
                --continue

        --    graphic\draw!

        for _, entity in ipairs @entities.values
            if (not entity.visible)
                continue

            entity\draw!


    addEntity: (entity) =>
        @entities\add(entity)
        entity\sceneAdded(@)

    removeEntity: (entity) =>
        if (@entities\remove(entity))
            entity\sceneRemoved!
