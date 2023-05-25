local PlayerAgent = {}
PlayerAgent.__index = PlayerAgent

local EventManager = require("scripts.Manager.EventManager")
local CameraManager = require("scripts.Manager.CameraManager")

function PlayerAgent.new(character)
  local self = setmetatable({}, PlayerAgent)
  self.character = character
  self.canDash = true
  self.dashTime = 0
  self.dashRecoverTime = 0
  return self
end

function PlayerAgent:update(dt)
  self:lookAt()
  self:attack()

  self.dashTime = self.dashTime - dt
  if self.dashTime <= 0 then
    self:moveDirection()

    if self.dashRecoverTime > 0 then
      self.dashRecoverTime = self.dashRecoverTime - dt
    else
      self.canDash = true
    end
  end
end

function PlayerAgent:stop(time)
  self.dashTime = time
end

function PlayerAgent:lookAt()
  local mouseX, mouseY = CameraManager.getMouseWorldPosition()
  local charX, charY = self.character:getPosition()
  self.character.transform.angle = math.atan2(mouseY - charY, mouseX - charX)
end

function PlayerAgent:attack()
  if love.mouse.isDown(1) then
    self.character:attack()
  end
end

function PlayerAgent:moveDirection()
  if love.keyboard.isDown("z", "q", "s", "d") then
    local angleDirection = 0

    -- LuaFormatter off
    if love.keyboard.isDown("d") and love.keyboard.isDown("z") then angleDirection = -45
    elseif love.keyboard.isDown("z") and love.keyboard.isDown("q") then angleDirection = -135
    elseif love.keyboard.isDown("q") and love.keyboard.isDown("s") then angleDirection = 135
    elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") then angleDirection = 45
    elseif love.keyboard.isDown("d") then angleDirection = 0
    elseif love.keyboard.isDown("z") then angleDirection = -90
    elseif love.keyboard.isDown("q") then angleDirection = 180
    elseif love.keyboard.isDown("s") then angleDirection = 90
    end
    -- LuaFormatter on

    angleDirection = math.rad(angleDirection)
    self.character.body:setDirection(math.cos(angleDirection), math.sin(angleDirection))
  else
    self.character.body:setDirection(0, 0)
  end

  if self.canDash and love.keyboard.isDown("lshift") then
    self.canDash = false
    self.dashTime = 0.2
    self.dashRecoverTime = 2
    EventManager.dispatch("PlayerDash")
    self.character:dash(3, self.dashTime)
  end
end

return PlayerAgent
