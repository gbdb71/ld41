love.load = ->
    -- util
    require "util/locker"

    -- graphics
    local c = require "graphics/color"
    export Colors = c.Colors
    require "graphics/graphic"
    require "graphics/image"

    -- core
    require "core/entity"
    require "core/scene"
    require "core/emptyScene"
    --require "core/input"

    -- game scenes
    require "scenes/gameplayScene"

    require "core/game"
    with game = Game!
        .pixelScale = Settings.pixel_scale

        -- input
        --Input!

        -- scenes
        \addScene("gameplay", GameplayScene!)

        \start("gameplay")
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
