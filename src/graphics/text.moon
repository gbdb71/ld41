export class Text extends Graphic
    new: (font, text) =>
        super!
        @text = love.graphics.newText(font, text)
        @quad = nil

    draw: (x=0, y=0, r=@orientation, sx=@scale.x, sy=@scale.y, ox=@origin.x, oy=@origin.y, kx=@shearing.x, ky=@shearing.y) =>
        cr, cg, cb, ca = love.graphics.getColor!
        love.graphics.setColor(@color[1], @color[2], @color[3], @opacity)

        if (@quad != nil)
            love.graphics.draw(@text, @quad, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
        else
            love.graphics.draw(@text, @x + x, @y + y, r, sx, sy, ox, oy, kx, ky)
            
        love.graphics.setColor(r, g, b, a)
