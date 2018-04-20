love.load = ->

love.update = (dt) ->

love.draw = ->
    love.graphics.print('Hello World!', 400, 300)
    return

love.keypressed = (key, scancode, isrepeat) ->
    print(key, scancode, isrepeat)
    return

love.keyreleased = (key, scancode) ->
    print(key, scancode)
    return
