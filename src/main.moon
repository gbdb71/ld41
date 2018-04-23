love.load = ->
    -- font
    Settings.fonts = {
        "04b03": "#{Settings.folders.fonts}/04b03.ttf"
    }

    Settings.stdFont = love.graphics.newFont(Settings.fonts["04b03"], 8)
    Settings.turnAnnouncerFont = love.graphics.newFont(Settings.fonts["04b03"], 16)
    Settings.gemCountFont = love.graphics.newFont(Settings.fonts["04b03"], 8)

    -- util
    m = require "util/math"
    export Math = m
    h = require "util/helper"
    export Helper = h
    require "util/locker"

    -- graphics
    c = require "graphics/color"
    export Colors = c.Colors
    require "graphics/graphic"
    require "graphics/image"
    require "graphics/imageSet"
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
    require "scenes/introScene"
    require "scenes/gameplayScene"

    require "core/game"
    with game = Game!
        .pixelScale = Settings.pixelScale
        .backgroundColor = Settings.backgroundColor

        -- input
        --with input = Input!
            --\registerKeyboard(Settings.input.keyboard)
            --\registerGamepad(Settings.input.gamepad)

        -- scenes
        \addScene("intro", IntroScene!)
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
