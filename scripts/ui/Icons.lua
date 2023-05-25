local Icons = {}

local killIcon = love.graphics.newImage("assets/images/ui/kill_icon.png")
local timeIcon = love.graphics.newImage("assets/images/ui/time_icon.png")

function Icons.draw(kill, time)
  love.graphics.setFont(love.graphics.newFont(20))
  love.graphics.draw(killIcon, 10, 75, 0, 2, 2)
  love.graphics.print(kill, 52, 77)
  love.graphics.draw(timeIcon, 10, 115, 0, 2, 2)
  love.graphics.print(time, 52, 120)
end

return Icons
