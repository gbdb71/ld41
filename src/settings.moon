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

settings.window_size =
    width: settings.screen_size.width * settings.pixel_scale
    height: settings.screen_size.height * settings.pixel_scale

-- assets
settings.atlas_name = "main atlas"

return settings
