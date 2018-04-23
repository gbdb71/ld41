export class Image extends Graphic
    new: (filename) =>
        super!
        @texture = love.graphics.newImage(filename)
        @quad = nil
        @flip = h: false, v: false

    draw: (x=0, y=0, r=@orientation, sx=@scale.x, sy=@scale.y, ox=@origin.x, oy=@origin.y, kx=@shearing.x, ky=@shearing.y) =>
        sx *= -1 if @flip.h
        sy *= -1 if @flip.v

        cr, cg, cb, ca = love.graphics.getColor!
        love.graphics.setColor(@color[1], @color[2], @color[3], @opacity)

        if (@quad != nil)
            love.graphics.draw(@texture, @quad, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
        else
            love.graphics.draw(@texture, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)

        love.graphics.setColor(cr, cg, cb, ca)
