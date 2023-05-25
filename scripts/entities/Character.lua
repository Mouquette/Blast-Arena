local Character = {}
Character.__index = Character

local Vector = require("scripts.Entities.Vector")
local Transform = require("scripts.Entities.Transform")
local PhysicBody = require("scripts.Entities.PhysicBody")
local CollisionManager = require("scripts.Manager.CollisionManager")

local shadowImg = love.graphics.newImage("assets/images/sprites/player/character_Shadow_15x4.png")

function Character.new(data, life)
  local self = setmetatable({}, Character)

  local x, y = data.x or 0, data.y or 0
  local size = data.size or 64
  self.initSpeed = data.speed or 500

  self.transform = Transform.new(x, y, size, 0)
  self.body = PhysicBody.new(self.transform, self.initSpeed)
  self.dashTime = 0
  self.look = 1

  self.weapon = nil
  self.controller = nil
  self.collision = nil
  self.animation = nil
  self.barLife = nil
  self.shadow = nil

  self.life = life or 100
  self.maxLife = self.life
  self.hitAnimationTimer = 0
  self.hitDirection = Vector.new({ x = 0, y = 0 })
  self.invincibilityTimer = 0
  self.deathAnimationTimer = 0.3

  return self
end

function Character:update(dt)
  -- Dash
  self.dashTime = self.dashTime - dt
  if self.dashTime <= 0 then
    self.body.speed = self.initSpeed
  end

  -- Dead
  if self:isDead() then
    self.deathAnimationTimer = self.deathAnimationTimer - dt
    self.animation:update(dt)
    return
  end

  -- Controller
  self.controller:update(dt)

  -- Timers
  if self.hitAnimationTimer > 0 then
    self.body:setDirection(self.hitDirection.x, self.hitDirection.y)
  end

  if self.hitAnimationTimer <= 0 and self.invincibilityTimer > 0 then
    self.invincibilityTimer = self.invincibilityTimer - dt
  end

  -- Move and look
  self.body:update(dt)
  self.look = math.abs(math.deg(self.body.transform.angle)) <= 90 and 1 or -1

  -- Move Collision
  local collisions = CollisionManager.tileCollision(self.transform)
  if #collisions > 0 then
    for _, collision in ipairs(collisions) do
      local normal = collision.vector:normalize()
      local penetration = (self.transform.size / 2) - collision.distance
      self.transform.position.x = self.transform.position.x + normal.x * penetration
      self.transform.position.y = self.transform.position.y + normal.y * penetration
    end
  end

  -- Weapon
  if self.weapon then
    self.weapon:update(dt, self)
  end

  -- Animation
  if self.hitAnimationTimer > 0 then
    self.hitAnimationTimer = self.hitAnimationTimer - dt
    if self.animation.currentAnimation ~= self.animation.animations["HURT"] then
      self.animation:setAnimation("HURT")
    end
  elseif self.controller.attacking then
    if self.animation.currentAnimation ~= self.animation.animations["ATCK"] then
      self.animation:setAnimation("ATCK")
    end
  elseif self.body:isMoving() and self.animation.currentAnimation ~= self.animation.animations["MOVE"] then
    self.animation:setAnimation("MOVE")
  elseif (not self.body:isMoving()) and self.animation.currentAnimation ~= self.animation.animations["IDLE"] then
    self.animation:setAnimation("IDLE")
  end
  self.animation:update(dt)

  -- Shadow
  if self.shadow then
    self.shadow.x = (self.look * self.shadow.posX) + self.transform.position.x
    self.shadow.y = self.shadow.posY + self.transform.position.y + self.transform.size / 2
  end
end

function Character:attack()
  if self.weapon then
    self.weapon:attack()
  end
end

function Character:dash(speedMultiplicator, dashTime)
  self.body.speed = self.initSpeed * speedMultiplicator
  self.dashTime = dashTime
end

function Character:hit(damage, direction, invincibility)
  if self.invincibilityTimer > 0 or self:isDead() then
    return
  end

  self.life = self.life - damage
  if self.barLife then
    self.barLife:update(self:getLifePercent())
  end

  if self.life <= 0 then
    self:die()
    return
  end

  self.hitAnimationTimer = 0.3
  self.hitDirection = direction

  if invincibility then
    self.invincibilityTimer = 1
  end
end

function Character:getLifePercent()
  return self.life / self.maxLife
end

function Character:die()
  self.life = 0
  self.weapon = nil
  self.animation:setAnimation("DEAD")
end

function Character:canDisapear()
  return self:isDead() and self.deathAnimationTimer <= 0
end

function Character:isDead()
  return self.life <= 0
end

function Character:isInvincible()
  return self.invincibilityTimer > 0
end

function Character:getPosition()
  return self.transform.position.x, self.transform.position.y
end

function Character:getDirection()
  return self.body.direction
end

function Character:setShadow(posX, posY)
  self.shadow = {}
  self.shadow.x = 0
  self.shadow.y = 0
  self.shadow.posX = posX
  self.shadow.posY = posY
  self.shadow.ox, self.shadow.oy = shadowImg:getWidth() / 2, shadowImg:getHeight() / 2
  self.shadow.scale = math.max(2.5, self.animation.spriteScale)
end

function Character:draw()
  if self.shadow then
    local shadow = self.shadow
    love.graphics.draw(shadowImg, shadow.x, shadow.y, 0, shadow.scale, shadow.scale, shadow.ox, shadow.oy)
  end

  if self.invincibilityTimer > 0 and self.hitAnimationTimer < 0 then
    love.graphics.setColor({ 1, 1, 1, math.sin(love.timer.getTime() * 100) + 0.75 })
  end

  if self.weapon and self.weapon.behind then
    self.weapon:draw()
  end

  if self.animation then
    local position = self.transform.position
    local ox, oy = self.animation:getOrigin()

    love.graphics.draw(self.animation:getSprite(), position.x, position.y, 0, self.look * self.animation.spriteScale,
                       self.animation.spriteScale, ox, oy)
  end

  if self.weapon and not self.weapon.behind then
    self.weapon:draw()
  end

  love.graphics.setColor({ 1, 1, 1, 1 })
  self.body:draw()

  if self.barLife then
    love.graphics.draw(self.barLife:getCanvas(), self.transform.position.x - self.transform.size / 2,
                       self.transform.position.y - self.transform.size / 2 - 10)
  end
end

return Character
