export class Gem extends Pickup
    new: (gemType) =>
        super!
        @value = 100
        @hasBeenCollected = false
        @timeToShineAgain = 3
        @nextShineChance = 0
        @clock = 0

        texturePath = "#{Settings.folders.graphics}/"
        if (gemType == "red")
            texturePath ..= "redgem.png"
            @value = 500
        else
            texturePath ..= "gem.png"

        with @graphic = Animation(texturePath, 9, 13)
            .origin.x = 5
            .origin.y = 6
            \addTrack("idle", "1-3", 130)\loop()
            \addTrack("shining", "4-7", 130)\onEnd( -> @graphic\play("idle"))
            \play("idle")

    update: (dt) =>
        super(dt)
        if (@hasBeenCollected)
            return

        @clock += dt
        if (@graphic.currentTrackLabel == "idle" and @nextShineChance <= @clock)
            @nextShineChance = @clock + @timeToShineAgain
            if (math.random(1, 100) <= 20)
                @graphic\play("shining")

    collect: (actor) =>
        if (@hasBeenCollected)
            return

        super(actor)
        if (actor.__class.__name == "Player")
            Settings.audio.content.sfx["coin"]\play!
            actor.gems += @value
            @removeSelf!
            @hasBeenCollected = true
