export class Graphic
    new: =>
        @texture = nil
        @x = 0
        @y = 0
        @orientation = 0
        @scale = x: 1, y: 1
        @origin = x: 0, y: 0
        @shearing = x: 0, y: 0
        @opacity = 1
        @color = { 255, 255, 255 }

    update: (dt) =>

    draw: (x=0, y=0, r=@orientation, sx=@scale.x, sy=@scale.y, ox=@origin.x, oy=@origin.y, kx=@shearing.x, ky=@shearing.y) =>
        if (@texture == nil)
            return

        cr, cg, cb, ca = love.graphics.getColor!
        love.graphics.setColor(@color[1], @color[2], @color[3], @opacity)

        love.graphics.draw(@texture, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)

        love.graphics.setColor(r, g, b, a)
