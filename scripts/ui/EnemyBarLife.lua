local EnemyBarLife = {}
EnemyBarLife.__index = EnemyBarLife

local width, height = 64, 4

function EnemyBarLife.new()
  local self = setmetatable({}, EnemyBarLife)
  self.canvas = love.graphics.newCanvas(width, height)
  return self
end

function EnemyBarLife:update(percent)
  love.graphics.setCanvas(self.canvas)
  love.graphics.setColor({ 90 / 255, 105 / 255, 136 / 255 })
  love.graphics.rectangle("fill", 0, 0, width, height)
  love.graphics.setColor({ 1, 0, 68 / 255 })
  love.graphics.rectangle("fill", 0, 0, width * percent, height)
  love.graphics.setCanvas()

  love.graphics.setColor({ 1, 1, 1 })
end

function EnemyBarLife:getCanvas()
  return self.canvas
end

return EnemyBarLife

