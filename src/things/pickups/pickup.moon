export class Pickup extends Entity
    new: =>
        super!


    sceneAdded: (scene) =>
        super(scene)
        gx, gy = @scene.grid\transformToGridPos(@x, @y)
        cell = @scene.grid\cellAt(gx, gy)
        cell.pickup = @

    collect: (actor) =>
