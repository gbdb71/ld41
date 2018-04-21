export class GameplayScene extends Scene
    new: =>
        super!
        require "things/actors/player/player"
        @player = Player!
        @addEntity(@player)

    enter: =>
        super!

    leave: =>
        super!

    update: (dt) =>
        super(dt)

    draw: =>
        super!
