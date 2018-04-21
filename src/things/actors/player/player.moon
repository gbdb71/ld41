export class Player extends Entity
    new: =>
        super!
        @graphic = Image("content/player.png")
        @movement = @addComponent(Movement(100, 100, 300, 300))

    draw: =>
        super!
        --love.graphics.polygon("fill", { @x, @y,  @x + 16, @y,  @x + 16, @y + 16,  @x, @y + 16 })
