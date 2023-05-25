local KamikazeAgent = {}
KamikazeAgent.__index = KamikazeAgent

function KamikazeAgent.new(character, player)
  local self = setmetatable({}, KamikazeAgent)
  self.character = character
  self.player = player
  return self
end

function KamikazeAgent:update(dt)
  self:lookAt()
  self:moveDirection()
end

function KamikazeAgent:lookAt()
  local playerX, playerY = self.player:getPosition()
  local x, y = self.character.transform.position.x, self.character.transform.position.y
  self.character.transform.angle = math.atan2(playerY - y, playerX - x)
end

function KamikazeAgent:moveDirection()
  self.character.body:setDirection(math.cos(self.character.transform.angle), math.sin(self.character.transform.angle))
end

return KamikazeAgent
