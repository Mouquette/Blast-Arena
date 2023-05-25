local AttackFactory = {}

-- MODULES

local EventManager = require("scripts.Manager.EventManager")
local Attack = require("scripts.Entities.Attack")

-- DATA

local playerAttack = {}
local enemiesAttack = {}

AttackFactory.getPlayerAttack = function()
  return playerAttack
end

AttackFactory.getEnemiesAttack = function()
  return enemiesAttack
end

function AttackFactory.reset()
  for i, v in ipairs(playerAttack) do
    table.remove(playerAttack, i)
  end

  for i, v in ipairs(enemiesAttack) do
    table.remove(enemiesAttack, i)
  end
end

-- CREATE MELEE ATTACK

AttackFactory.meleeAttack = {
  new = function(data, damage, weapon)
    local attackData = { x = data.x, y = data.y, size = data.size or 32, angle = data.angle, speed = 0 }
    local attack = Attack.new(attackData, damage)
    EventManager.dispatch("Melee")

    attack.updateFn = function(self)
      self.transform.position.x = weapon.position.x
      self.transform.position.y = weapon.position.y

      if self.lifeTime > 0.2 then
        for i, v in ipairs(enemiesAttack) do
          if v == attack then
            table.remove(enemiesAttack, i)
            break
          end
        end
      end
    end

    table.insert(enemiesAttack, attack)
  end
}

-- CREATE GUN BULLETS

local GunImage = love.graphics.newImage("assets/images/sprites/bullet/bullet.png")
local GunDraw = function(self)
  local x, y = self.body.transform.position.x, self.body.transform.position.y
  local angle = self.body.transform.angle
  local size = self.body.transform.size

  if self.lifeTime < 0.02 then
    love.graphics.circle("fill", x, y, size / 2)
  else
    local scaleX = self.lifeTime < 0.05 and 2 or 4
    local scaleY = self.lifeTime < 0.05 and 2 or 1
    love.graphics.draw(GunImage, x, y, angle, scaleX, scaleY, GunImage:getWidth() / 2, GunImage:getHeight() / 2)
  end
end

AttackFactory.gunBullet = {
  new = function(data, damage)
    EventManager.dispatch("shakeCamera", 5, 0.1)

    local attackData = { x = data.x, y = data.y, size = 32, angle = data.angle, speed = 2000 }
    local attack = Attack.new(attackData, damage)
    attack.drawFn = GunDraw

    EventManager.dispatch("Shoot")
    table.insert(playerAttack, attack)
  end
}

return AttackFactory
