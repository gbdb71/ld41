export class Scene
    new: =>
        @graphics = Locker!
        @entities = Locker((a, b) -> a.layer < b.layer)

    enter: =>
        @entities\lock!
        for _, entity in ipairs @entities.values
            if (entity.scene != @)
                entity\sceneEnter!

        @entities\unlock!

    leave: =>
        @entities\lock!
        for _, entity in ipairs @entities.values
            if (entity.scene != @)
                entity\sceneLeave!

        @entities\unlock!

    beforeUpdate: =>
        @entities\lock!
        for _, entity in ipairs @entities.values
            if (not entity.active or entity.scene != @)
                continue

            entity\beforeUpdate!

        @entities\unlock!

    update: (dt) =>
        @entities\lock!
        for _, entity in ipairs @entities.values
            if (not entity.active or entity.scene != @)
                continue

            entity\update(dt)

        @entities\unlock!

    lateUpdate: =>
        @entities\lock!
        for _, entity in ipairs @entities.values
            if (not entity.active or entity.scene != @)
                continue

            entity\lateUpdate!

        @entities\unlock!

        @entities\keep!


    draw: =>
        --for _, graphic in ipairs @graphics.values
            --if (not graphic.visible)
                --continue

        --    graphic\draw!

        @entities\lock!
        for _, entity in ipairs @entities.values
            if (not entity.visible or entity.scene != @)
                continue

            entity\draw!

        @entities\unlock!


    addEntity: (entity) =>
        @entities\add(entity)
        entity\sceneAdded(@)

    removeEntity: (entity) =>
        if (entity.scene != @)
            return

        if (@entities\remove(entity))
            entity\sceneRemoved!

    toString: =>
        "entities: #{@entities\toString!}

graphics: #{@graphics\toString!}"
