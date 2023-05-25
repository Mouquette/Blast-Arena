local MeleeAgent = {}
MeleeAgent.__index = MeleeAgent

local Vector = require("scripts.Entities.Vector")

function MeleeAgent.new(character, player)
  local self = setmetatable({}, MeleeAgent)
  self.character = character
  self.player = player

  self.attacking = false
  self.attackTimer = 0

  return self
end

function MeleeAgent:update(dt)
  if self.attacking then
    self.attackTimer = self.attackTimer - dt
    if self.attackTimer <= 0 then
      self.attacking = false
    elseif self.attackTimer <= 0.2 then
      self.character:attack()
    end
  elseif self:closeToPlayer() then
    self:attack()
  end

  self:lookAt()
  self:moveDirection()
end

function MeleeAgent:lookAt()
  local playerX, playerY = self.player:getPosition()
  local x, y = self.character.transform.position.x, self.character.transform.position.y
  self.character.transform.angle = math.atan2(playerY - y, playerX - x)
end

function MeleeAgent:closeToPlayer()
  local playerX, playerY = self.player:getPosition()
  local x, y = self.character.transform.position.x, self.character.transform.position.y
  local vector = Vector.new({ x = playerX - x, y = playerY - y })
  return vector:length() < (self.character.transform.size + 32)
end

function MeleeAgent:moveDirection()
  self.character.body:setDirection(math.cos(self.character.transform.angle), math.sin(self.character.transform.angle))
end

function MeleeAgent:attack()
  self.attacking = true
  self.attackTimer = 0.5
end

return MeleeAgent
