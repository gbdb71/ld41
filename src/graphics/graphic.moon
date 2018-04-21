export class Graphic
    new: =>
        @drawable = nil
        @x = 0
        @y = 0
        @orientation = 0
        @scale = x: 1, y: 1
        @origin = x: 0, y: 0
        @shearing = x: 0, y: 0

    draw: (x=0, y=0, r=@orientation, sx=@scale.x, sy=@scale.y, ox=@origin.x, oy=@origin.y, kx=@shearing.x, ky=@shearing.y) =>
        if (@drawable == nil)
            return

        love.graphics.draw(@drawable, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
