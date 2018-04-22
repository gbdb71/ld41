settings = {}

-- about
settings.gameName = "LD41"
settings.description = "Game made in 72 hours to Ludum Dare 41."
settings.link = "-"

settings.authors =
    "Luke": {
        role: "programmer"
        links:
            twitter: "@itsmappache"
            github:"github.com/lucas-miranda"
    }

    "Rey": {
        role: "artist"
        links:
            twitter: "@reylisten"
            itchio: "reylisten.itch.io"
    }

-- window
settings.title = "#{settings.gameName}"
settings.pixelScale = 4

settings.screenSize =
    width: 320
    height: 180

settings.screenCenter =
    x: settings.screenSize.width / 2
    y: settings.screenSize.height / 2

settings.windowSize =
    width: settings.screenSize.width * settings.pixelScale
    height: settings.screenSize.height * settings.pixelScale

settings.windowCenter =
    x: settings.windowSize.width / 2
    y: settings.windowSize.height / 2

-- assets
settings.folders = {}
settings.folders.content = "content"
settings.folders.fonts = "#{settings.folders.content}/fonts"
settings.folders.graphics = "#{settings.folders.content}/graphics"
settings.folders.maps = "#{settings.folders.content}/maps"

settings.atlasName = "main atlas"

-- fonts
settings.fonts = {}
settings.stdFont = nil
settings.turnAnnouncerFont = nil

-- grid
settings.tileSize =
    width: 16
    height: 16

-- input
settings.input = {
    keyboard: {
        -- gameplay
        "movement": {
            up: { "up", "w" }
            right: { "right", "d" }
            down: { "down", "s" }
            left: { "left", "a" }
        }

        "action": "z"
        --"pause": [ "return", "escape" ]

        -- ui
        "menuMove": {
            up: "up"
            right: "right"
            down: "down"
            left: "left"
        }
        "confirm": "z"
        "cancel": "x"
    }
}

-- entity layers
settings.layers = {
    entity: {
        ui: 1000
        effects: 200
        projectiles: 100
        actors: 50
        scenario: 0
    }
}

-- turns
settings.turnChangeDelay = .2
settings.turns = {
    player:
        id: 1
        name: "Player"
        active: true

    enemies:
        id: 2
        name: "Enemies"
        active: false
}

-- rooms
settings.changeRoomDelay = 2

return settings
