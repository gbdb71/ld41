export class UI extends Entity
    new: =>
        super!

        with @heart = ImageSet("#{Settings.folders.graphics}/ui_heart.png", 10, 7)
            .y = 5

        @maxHearts = 1
        @hearts = @maxHearts
        @heartHorizontalSpace = 2

        @horizontalDivision = 5

        with @gem = Image("#{Settings.folders.graphics}/ui_gem.png")
            .y = 2

        @gems = 0
        @initialGems = 0
        @showGems = 0

        @textMargin = 4
        with @gemText = Text(Settings.gemCountFont, "#{@gems}")
            .y = 5

        @playingGemTween = false
        @gemTweenProgress = 0


    update: (dt) =>
        super(dt)
        if (@gemAddTween != nil and @playingGemTween)
            if (@gemAddTween\update(dt))
                @playingGemTween = false

            @showGems = Lume.round(Lume.lerp(@initialGems, @gems, @gemTweenProgress))
            @gemText.text\set("#{@showGems}")

    draw: =>
        super!

        -- hearts
        x = 8
        for i = 0, @maxHearts - 1
            if (@hearts - 1 >= i)
                @heart\setFrame(1) -- full heart
            else
                @heart\setFrame(2) -- empty heart

            @heart\draw(x, 0)
            x += @heart.frame.width + @heartHorizontalSpace

        --

        x += @horizontalDivision

        -- gems
        @gem\draw(x, 0)
        @gemText\draw(x + @gem.texture\getWidth! + @textMargin, 0)


    setHeart: (amount) =>
        @hearts = Lume.clamp(amount, 0, @maxHearts)

    setGem: (amount) =>
        if (@gems == amount)
            return

        @initialGems = @gems
        @gems = amount
        diff = @gems - @initialGems
        @gemTweenProgress = 0
        @gemAddTween = Tween.new(.1 + (diff / 100.0) * .05, @, { gemTweenProgress: 1.0 })
        @playingGemTween = true

    addGem: (amount) =>
        @setGem(@gems + amount)

    resetGems: =>
        @showGems = 0
        @gems = 0
        @initialGems = 0
        @gemTweenProgress = 0
        @gemAddTween = nil
        @playingGemTween = false
