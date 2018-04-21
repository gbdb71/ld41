love.load = ->
    -- util
    require "util/locker"

    -- core
    require "core/game"
    require "core/entity"
    require "core/scene"
    require "core/emptyScene"
    --require "core/input"

    -- graphic
    require "graphics/graphic"
    require "graphics/image"

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
