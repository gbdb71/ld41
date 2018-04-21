export class EmptyScene extends Scene
    draw: =>
        super!
        love.graphics.print("Empty Scene", Settings.screenCenter.x, Settings.screenCenter.y)
