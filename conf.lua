DEBUG_MODE = false
DEMO_MODE = true

function love.conf(t)
  t.window.title = "Blast Arena"

  t.window.fullscreen = false
  t.window.width = 1280
  t.window.height = 720
  t.console = DEBUG_MODE

  t.modules.data = false
  t.modules.physics = false
  t.modules.touch = false
end
