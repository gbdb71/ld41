love.load = ->
    -- font
    Settings.fonts = {
        "04b03": "#{Settings.folders.fonts}/04b03.ttf"
    }

    Settings.stdFont = love.graphics.newFont(Settings.fonts["04b03"], 8)
    Settings.turnAnnouncerFont = love.graphics.newFont(Settings.fonts["04b03"], 16)

    -- util
    m = require "util/math"
    export Math = m
    require "util/locker"

    -- graphics
    c = require "graphics/color"
    export Colors = c.Colors
    require "graphics/graphic"
    require "graphics/image"
    require "graphics/animation"
    require "graphics/animationTrack"
    require "graphics/text"

    -- core
    require "core/components/component"
    require "core/components/movement"
    require "core/entity"
    require "core/scene"
    require "core/emptyScene"

    -- game scenes
    require "scenes/gameplayScene"

    require "core/game"
    with game = Game!
        .pixelScale = Settings.pixelScale

        -- input
        --with input = Input!
            --\registerKeyboard(Settings.input.keyboard)
            --\registerGamepad(Settings.input.gamepad)

        -- scenes
        \addScene("gameplay", GameplayScene!)

        \start("gameplay")
    return

love.update = (dt) ->
    Game.instance\update(dt)
    return

love.draw = ->
    Game.instance\draw!
    return

love.keypressed = (key, scancode, isrepeat) ->
    return

love.keyreleased = (key, scancode) ->
    return
