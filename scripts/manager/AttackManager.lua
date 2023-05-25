local AttackManager = {}

-- MODULES

local EventManager = require("scripts.Manager.EventManager")
local AttackFactory = require("scripts.Factories.AttackFactory")
local CollisionManager = require("scripts.Manager.CollisionManager")

-- ATTACKS

local playerAttack = AttackFactory.getPlayerAttack()
local enemiesAttack = AttackFactory.getEnemiesAttack()

function AttackManager.reset()
  AttackFactory.reset()
end

-- PLAYER ATTACK
local function playerAttackCollision(attack, enemies)
  if not enemies then
    return false
  end

  for _, enemy in ipairs(enemies) do
    if CollisionManager.bodyCollision(attack, enemy) then
      enemy:hit(attack.damage, attack:getDirection())
      if enemy:isDead() then
        EventManager.dispatch("EnemyKilled")
      else
        EventManager.dispatch("Hit")
      end
      return true
    end
  end

  return false
end

function AttackManager.updatePlayerAttack(dt, enemiesPosition)
  for i = #playerAttack, 1, -1 do
    local attack = playerAttack[i]
    attack:update(dt)

    local collisions, tiles = CollisionManager.tileCollision(attack.transform)
    for _, tile in ipairs(tiles) do
      local enemies = enemiesPosition[tile.x .. "-" .. tile.y]
      if playerAttackCollision(attack, enemies) then
        table.remove(playerAttack, i)
        goto continue
      end
    end

    if #collisions > 0 then
      for _, collision in ipairs(collisions) do
        -- TODO: Add attack to waitForDestroy or Add particle
        table.remove(playerAttack, i)
      end
    end

    ::continue::
  end
end

-- ENEMIES ATTACK

function AttackManager.updateEnemiesAttack(dt, player)
  for i = #enemiesAttack, 1, -1 do
    local attack = enemiesAttack[i]
    attack:update(dt)

    if CollisionManager.bodyCollision(attack, player) then
      AttackManager.PlayerHit(player, attack.damage, attack:getDirection())
      table.remove(enemiesAttack, i)
      goto continue
    end

    local collisions = CollisionManager.tileCollision(attack.transform)
    if #collisions > 0 then
      for _, collision in ipairs(collisions) do
        -- TODO: Add attack to waitForDestroy or Add particle
        table.remove(enemiesAttack, i)
      end
    end

    ::continue::
  end
end

-- PLAYER HIT

function AttackManager.PlayerHit(player, damage, direction)
  local wasInvincible = player:isInvincible()

  player:hit(damage, direction, true)
  EventManager.dispatch("playerLifePercent", player:getLifePercent())

  if player:isDead() then
    EventManager.dispatch("Death")
  elseif not wasInvincible then
    EventManager.dispatch("Hurt")
  end
end

-- DRAW

function AttackManager.drawAttacks()
  for _, attack in ipairs(enemiesAttack) do
    attack:draw()
  end

  for _, attack in ipairs(playerAttack) do
    attack:draw()
  end
end

return AttackManager
