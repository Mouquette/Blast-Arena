local Weapon = {}
Weapon.__index = Weapon

local Vector = require("scripts.Entities.Vector")

function Weapon.new(data, img)
  local self = setmetatable({}, Weapon)

  self.canAttack = true
  self.attackTimer = 0

  self.fireRate = data.fireRate
  self.minDamage = data.minDamage
  self.maxDamage = data.maxDamage

  if data.attackModule then
    self.attackModule = data.attackModule
  end

  self.flip = 1
  self.angle = 0
  self.behind = false
  self.radius = data.radius
  self.position = Vector.new({ x = 0, y = 0 })
  self.origin = { x = 0, y = 0 }

  if img then
    self.img = img
  end

  return self
end

function Weapon:getPosition()
  return self.position.x, self.position.y
end

function Weapon:attack()
  if self.canAttack then
    self.canAttack = false
    self.attackTimer = self.fireRate

    if self.attackModule then
      local damage = math.random(self.minDamage, self.maxDamage)
      local data = { x = self.position.x, y = self.position.y, angle = self.angle }
      self.attackModule.new(data, damage, self)
    end
  end
end

function Weapon:update(dt, character)
  self.attackTimer = self.attackTimer - dt
  if self.attackTimer <= 0 then
    self.canAttack = true
  end

  self.flip = character.look
  self.behind = character.transform.angle < 0 and true or false

  self.angle = character.transform.angle
  self.position.x = character.transform.position.x + math.cos(self.angle) * self.radius
  self.position.y = character.transform.position.y + math.sin(self.angle) * self.radius

  if self.img then
    self.origin.x = self.img:getWidth() / 2
    self.origin.y = self.img:getHeight() / 2
  end
end

function Weapon:draw()
  if self.img then
    local weapongAngle = self.flip == -1 and self.angle + math.rad(180) or self.angle
    local x, y = self.position.x, self.position.y
    local ox, oy = self.origin.x, self.origin.y
    love.graphics.draw(self.img, x, y, weapongAngle, self.flip, 1, ox, oy)
  end
end

return Weapon
