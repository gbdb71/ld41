settings = {}

-- about
settings.game_name = "LD41"
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
settings.title = "#{settings.game_name}"
settings.pixel_scale = 4

settings.screen_size =
    width: 320
    height: 180

settings.screen_center =
    x: settings.screen_size.width / 2
    y: settings.screen_size.height / 2

settings.window_size =
    width: settings.screen_size.width * settings.pixel_scale
    height: settings.screen_size.height * settings.pixel_scale

settings.window_center =
    x: settings.window_size.width / 2
    y: settings.window_size.height / 2

-- assets
settings.atlas_name = "main atlas"

return settings
