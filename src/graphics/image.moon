export class Image extends Graphic
    new: (filename) =>
        super!
        @texture = love.graphics.newImage(filename)
        @quad = nil

    draw: (x=0, y=0, r=@orientation, sx=@scale.x, sy=@scale.y, ox=@origin.x, oy=@origin.y, kx=@shearing.x, ky=@shearing.y) =>
        if (@quad != nil)
            love.graphics.draw(@texture, @quad, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
            return

        love.graphics.draw(@texture, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
