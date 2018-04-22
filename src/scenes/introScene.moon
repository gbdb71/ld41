export class IntroScene extends Scene
    new: =>
        super!
        with @deadcat = ImageSet("#{Settings.folders.graphics}/deadcat.png", 320, 180)
            .frameDuration = .050

        @tween = Tween.new(2.5, @deadcat, { opacity: 0.0 }, "outQuad")
        @playing = "logo"


    enter: =>
        super!
        @tween\reset!
        @deadcat\play!
        @playing = "logo"


    update: (dt) =>
        super(dt)

        switch (@playing)
            when "logo"
                if (@deadcat\update(dt))
                    @playing = "fadeout"
            when "fadeout"
                if (@tween\update(dt))
                    @playing = "switchScene"
                    Game.instance\changeScene("gameplay")


    draw: =>
        super!
        @deadcat\draw!
