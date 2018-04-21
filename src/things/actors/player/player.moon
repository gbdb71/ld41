export class Player extends Entity
    new: =>
        super!

    draw: =>
        super!
        love.graphics.polygon("fill", { @x, @y,  @x + 16, @y,  @x + 16, @y + 16,  @x, @y + 16 })
