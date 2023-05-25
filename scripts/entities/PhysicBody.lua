local PhysicBody = {}
PhysicBody.__index = PhysicBody

local Vector = require("scripts.Entities.Vector")

function PhysicBody.new(transform, speed)
  local self = setmetatable({}, PhysicBody)

  self.speed = speed
  self.transform = transform
  self.direction = Vector.new({ x = 0, y = 0 })

  return self
end

function PhysicBody:setDirection(x, y)
  self.direction = Vector.new({ x = x, y = y })
end

function PhysicBody:isMoving()
  return self.direction.x ~= 0 or self.direction.y ~= 0
end

function PhysicBody:update(dt)
  self.transform.position.x = self.transform.position.x + self.direction.x * self.speed * dt
  self.transform.position.y = self.transform.position.y + self.direction.y * self.speed * dt
end

function PhysicBody:draw()
  if DEBUG_MODE then
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor({ 0, 0, 1 })
    love.graphics.circle("line", self.transform.position.x, self.transform.position.y, self.transform.size / 2)
    love.graphics.setColor(r, g, b, a)
  end
end

return PhysicBody
