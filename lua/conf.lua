love.conf = function(t)
  Lume = require("lib/lume")
  Settings = require("settings")
  t.author = Lume.format("{1}, {2} and {3}", {
    Settings.authors["Luke"],
    Settings.authors["Rey"],
    ""
  })
  t.url = ""
  t.identity = ""
  t.version = "11.1"
  t.console = true
  t.window.title = Settings.title
  t.window.icon = nil
  t.window.width = Settings.window_size.width
  t.window.height = Settings.window_size.height
  t.window.borderless = false
  t.window.resizable = false
  t.window.minwidth = t.window.width
  t.window.minheight = t.window.height
  t.window.fullscreen = false
  t.window.fullscreentype = "exclusive"
  t.window.vsync = true
  t.window.fsaa = 0
  t.window.display = 1
  t.window.highdpi = false
  t.window.srgb = false
  t.window.x = nil
  t.window.y = nil
  t.modules.audio = true
  t.modules.event = true
  t.modules.graphics = true
  t.modules.image = true
  t.modules.joystick = true
  t.modules.keyboard = true
  t.modules.math = true
  t.modules.mouse = true
  t.modules.physics = true
  t.modules.sound = true
  t.modules.system = true
  t.modules.timer = true
  t.modules.window = true
  t.modules.thread = true
end
