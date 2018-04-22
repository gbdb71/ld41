export class Image extends Graphic
    new: (filename) =>
        super!
        @texture = love.graphics.newImage(filename)
        @quad = nil
        @flip = h: false, v: false

    draw: (x=0, y=0, r=@orientation, sx=@scale.x, sy=@scale.y, ox=@origin.x, oy=@origin.y, kx=@shearing.x, ky=@shearing.y) =>
        sx *= -1 if @flip.h
        sy *= -1 if @flip.v

        love.graphics.setColor(255, 255, 255, @opacity)
        if (@quad != nil)
            love.graphics.draw(@texture, @quad, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
            return

        love.graphics.draw(@texture, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
        love.graphics.setColor(255, 255, 255, 255)
