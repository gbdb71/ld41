export class EmptyScene extends Scene
    draw: =>
        super!
        love.graphics.print "Empty Scene", Settings.window_center.x, Settings.window_center.y
