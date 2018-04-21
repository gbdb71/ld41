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
settings.atlasName = "main atlas"

return settings
