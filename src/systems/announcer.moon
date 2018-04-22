export class Announcer
    new: (x=0, y=x) =>
        @startX = x
        @startY = y

        with @text = Text(Settings.turnAnnouncerFont, "")
            .x = @startX
            .y = @startY

        @playing = false

        @effects = {
            in:
                tween: Tween.new(
                    .9
                    @text
                    { y: Settings.screenCenter.y - 32 }
                    "outCubic"
                )

                next: "out"

            out:
                tween: Tween.new(
                    .7
                    @text
                    { opacity: 0.0 }
                    "inQuad"
                )
        }

        @startEffect = "in"
        @currentEffect = @effects[@startEffect]

        @callbacks = {
            onEnd: nil
        }


    update: (dt) =>
        if (not @playing)
            return

        if (@currentEffect.tween\update(dt))
            if (@currentEffect.next == nil)
                @stop!
            else
                @currentEffect = @effects[@currentEffect.next]

    draw: =>
        if (not @playing)
            return

        @text\draw!


    play: (text, onEnd) =>
        for name, effect in pairs @effects
            effect.tween\reset!

        @playing = true
        @currentEffect = @effects[@startEffect]
        @text.text\set({
            { Lume.color("rgba(61, 0, 122, 1)") }
            text
        })
        @text.x = @startX - @text.text\getWidth! / 2
        @callbacks.onEnd = onEnd

    stop: =>
        if (not @playing)
            return

        @playing = false

        if (@callbacks.onEnd != nil)
            @callbacks.onEnd!
