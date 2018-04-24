export class Chest extends Entity
    new: =>
        super!
        @isOpened = false

        with @graphic = ImageSet("#{Settings.folders.graphics}/chest.png", 29, 35)
            .origin.x = 15
            .origin.y = 22

        with @finalGem = Image("#{Settings.folders.graphics}/final_gem.png")
            .origin.x = 14
            .origin.y = 18

        @finalGemTween = Tween.new(3, @finalGem, { y: -22 }, "outQuad")

    sceneAdded: (scene) =>
        super(scene)
        gx, gy = @scene.grid\transformToGridPos(@x, @y)
        cell = @scene.grid\cellAt(gx, gy)
        cell.thing = @

    update: (dt) =>
        super(dt)
        if (@isOpened)
            @finalGemTween\update(dt)

    draw: =>
        super!
        if (@isOpened)
            @finalGem\draw(@x, @y)

    open: =>
        @isOpened = true
        @graphic\setFrame(2)
        @scene\callGoodEnd!
