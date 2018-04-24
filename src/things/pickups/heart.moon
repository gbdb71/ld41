export class Heart extends Pickup
    new: =>
        super!
        @value = 1
        @hasBeenCollected = false

        with @graphic = Image("#{Settings.folders.graphics}/heart.png")
            .origin.x = 5
            .origin.y = 4

    update: (dt) =>
        super(dt)
        if (@hasBeenCollected)
            return

    collect: (actor) =>
        if (@hasBeenCollected)
            return

        super(actor)
        if (actor.__class.__name == "Player")
            actor\takeHeal(@value)
            @removeSelf!
            @hasBeenCollected = true
