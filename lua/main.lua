io.stdout:setvbuf("no")
love.load = function() end
love.update = function(dt) end
love.draw = function()
  love.graphics.print('Hello World!', 400, 300)
end
love.keypressed = function(key, scancode, isrepeat)
  print(key, scancode, isrepeat)
end
love.keyreleased = function(key, scancode)
  print(key, scancode)
end
