export class Text extends Graphic
    new: (font, text) =>
        super!
        @text = love.graphics.newText(font, text)
        @quad = nil

    draw: (x=0, y=0, r=@orientation, sx=@scale.x, sy=@scale.y, ox=@origin.x, oy=@origin.y, kx=@shearing.x, ky=@shearing.y) =>
        love.graphics.setColor(255, 255, 255, @opacity)
        if (@quad != nil)
            love.graphics.draw(@text, @quad, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
            return

        love.graphics.draw(@text, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
        love.graphics.setColor(255, 255, 255, 255)
