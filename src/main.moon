love.load = ->
    -- font
    Settings.stdFont = love.graphics.newFont(Settings.fonts["04b03"], 8)
    Settings.turnAnnouncerFont = love.graphics.newFont(Settings.fonts["04b03"], 16)
    Settings.gemCountFont = love.graphics.newFont(Settings.fonts["04b03"], 8)

    -- audio
    -- music
    for name, filename in pairs Settings.audio.filenames.music
        music = love.audio.newSource("#{Settings.folders.audio}/#{filename}", "static")
        music\setVolume(.25)
        Settings.audio.content.music[name] = music
        music\setLooping(true)

    -- sfx
    for name, filename in pairs Settings.audio.filenames.sfx
        sfx = love.audio.newSource("#{Settings.folders.audio}/#{filename}", "static")
        sfx\setVolume(.4)
        Settings.audio.content.sfx[name] = sfx

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
    require "scenes/defeatScene"

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
        \addScene("defeat", DefeatScene!)

        \start("intro")
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
