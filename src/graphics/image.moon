export class Image extends Graphic
    new: (filename) =>
        super!
        @drawable = love.graphics.newImage(filename)
