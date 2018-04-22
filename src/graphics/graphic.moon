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

    update: (dt) =>

    draw: (x=0, y=0, r=@orientation, sx=@scale.x, sy=@scale.y, ox=@origin.x, oy=@origin.y, kx=@shearing.x, ky=@shearing.y) =>
        if (@texture == nil)
            return

        love.graphics.setColor(255, 255, 255, @opacity)
        love.graphics.draw(@texture, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
        love.graphics.setColor(255, 255, 255, 255)
