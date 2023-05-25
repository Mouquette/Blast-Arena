local Attack = {}
Attack.__index = Attack

local Transform = require("scripts.Entities.Transform")
local PhysicBody = require("scripts.Entities.PhysicBody")

function Attack.new(data, damage)
  local self = setmetatable({}, Attack)

  self.transform = Transform.new(data.x, data.y, data.size, data.angle)
  self.body = PhysicBody.new(self.transform, data.speed)
  self.body:setDirection(math.cos(data.angle), math.sin(data.angle))

  self.damage = damage
  self.lifeTime = 0

  self.updateFn = nil
  self.drawFn = nil

  return self
end

function Attack:getPosition()
  return self.body.transform.position.x, self.body.transform.position.y
end

function Attack:getDirection()
  return self.body.direction
end

function Attack:update(dt)
  self.lifeTime = self.lifeTime + dt
  if self.updateFn then
    self:updateFn()
  end
  self.body:update(dt)
end

function Attack:draw()
  if self.drawFn then
    self:drawFn()
  elseif DEBUG_MODE then
    love.graphics.setColor({ 1, 0, 0 })
    love.graphics.circle("fill", self.body.transform.position.x, self.body.transform.position.y,
                         self.body.transform.size)
    love.graphics.setColor({ 1, 1, 1 })
  end

end

return Attack
