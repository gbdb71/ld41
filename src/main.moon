love.load = ->
    -- core
    require "core/game"
    require "core/scene"
    require "core/emptyScene"
    --require "core/input"

    with game = Game!
        -- input
        love.keyboard.setKeyRepeat true
        --Input!

        -- scenes
        require "scenes/gameplayScene"
        game\addScene("gameplay", GameplayScene!)

        game\start("gameplay")
    return

love.update = (dt) ->
    Game.instance\update(dt)
    return

love.draw = ->
    Game.instance\draw()
    return

love.keypressed = (key, scancode, isrepeat) ->
    return

love.keyreleased = (key, scancode) ->
    return
