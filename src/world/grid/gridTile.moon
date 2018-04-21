export class GridTile
    new: =>
        @walkable = true

    draw: (x, y, cellWidth, cellHeight) =>
        love.graphics.rectangle("line", x, y, cellWidth, cellHeight)
