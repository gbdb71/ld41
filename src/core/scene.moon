export class Scene
    new: =>
        @graphics = Locker!
        @entities = Locker((a, b) -> a.layer < b.layer)

    enter: =>
        @entities\lock!
        for _, entity in ipairs @entities.values
            entity\sceneEnter!

        @entities\unlock!

    leave: =>
        @entities\lock!
        for _, entity in ipairs @entities.values
            entity\sceneLeave!

        @entities\unlock!

    beforeUpdate: =>
        @entities\keep!

        @entities\lock!
        for _, entity in ipairs @entities.values
            if (not entity.active)
                continue

            entity\beforeUpdate!

        @entities\unlock!

    update: (dt) =>
        @entities\lock!
        for _, entity in ipairs @entities.values
            if (not entity.active)
                continue

            entity\update(dt)

        @entities\unlock!

    lateUpdate: =>
        @entities\lock!
        for _, entity in ipairs @entities.values
            if (not entity.active)
                continue

            entity\lateUpdate!

        @entities\unlock!


    draw: =>
        --for _, graphic in ipairs @graphics.values
            --if (not graphic.visible)
                --continue

        --    graphic\draw!

        @entities\lock!
        for _, entity in ipairs @entities.values
            if (not entity.visible)
                continue

            entity\draw!

        @entities\unlock!


    addEntity: (entity) =>
        @entities\add(entity)
        entity\sceneAdded(@)

    removeEntity: (entity) =>
        if (@entities\remove(entity))
            entity\sceneRemoved!

    toString: =>
        "entities: #{@entities\toString!}

graphics: #{@graphics\toString!}"
