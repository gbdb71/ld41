love.load = ->
    -- core
    require "core/game"
    require "core/scene"
    require "core/emptyScene"

    -- game initialization
    Game!

    -- scenes
    require "scenes/gameplayScene"
    Game.instance\addScene("gameplay", GameplayScene!)

    Game.instance\start("gameplay")
    return

love.update = (dt) ->
    Game.instance\update(dt)
    return

love.draw = ->
    Game.instance\draw()
    return

love.keypressed = (key, scancode, isrepeat) ->
    print(key, scancode, isrepeat)
    return

love.keyreleased = (key, scancode) ->
    print(key, scancode)
    return
