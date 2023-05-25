local CharacterManager = {}

-- MODULES

local EventManager = require("scripts.Manager.EventManager")
local CharacterFactory = require("scripts.Factories.CharacterFactory")
local CollisionManager = require("scripts.Manager.CollisionManager")
local AttackManager = require("scripts.Manager.AttackManager")
local WaveManager = require("scripts.Manager.WaveManager")
local PlayerAnimation = require("scripts.Entities.Animation.PlayerAnimation")
local EnemyBarLife = require("scripts.UI.EnemyBarLife")

-- CHARACTERS

local player = nil

local enemies = {}
local killedEnemies = {}
local enemiesPosition = {}
local maxEnemies = 100

local spawnTimer = 0
local spawnRadius = 1000

-- INITIALIZE

function CharacterManager.initialize(LevelManager)
  local mapWidth, mapHeight = LevelManager.getMapSize()
  player = CharacterFactory.createPlayer(mapWidth / 2, mapHeight / 2)

  enemies = {}
  killedEnemies = {}
  enemiesPosition = {}
end

-- SPAWN

function CharacterManager.spawnEnemy(dt, LevelManager)
  spawnTimer = spawnTimer + dt

  local canSpawn = spawnTimer >= WaveManager.getWaveSpawnSpeed() and #enemies < maxEnemies
  if not canSpawn then
    return
  end

  spawnTimer = 0

  local angle = love.math.random() * math.pi * 2
  local playerX, playerY = player:getPosition()
  local spawnX = playerX + math.cos(angle) * spawnRadius
  local spawnY = playerY + math.sin(angle) * spawnRadius

  local tileX, tileY = LevelManager.getTilePosition(spawnX, spawnY)
  if LevelManager.isTileCollision(tileX, tileY) then
    CharacterManager.spawnEnemy(dt, LevelManager)
  else
    local enemy = WaveManager.createEnemy(spawnX, spawnY)
    enemy.barLife = EnemyBarLife.new()
    enemy.barLife:update(1)
    table.insert(enemies, enemy)
  end
end

-- UNSPAWN

function CharacterManager.removeEnemy(enemy)
  for i, e in ipairs(enemies) do
    if e == enemy then
      table.remove(enemies, i)
      break
    end
  end
end

-- CLEAR KILLED ENEMIES

function CharacterManager.clearKilledEnemies(dt)
  for i, enemy in ipairs(killedEnemies) do
    enemy:update(dt)
    if enemy:canDisapear() then
      table.remove(killedEnemies, i)
    end
  end
end

-- UPDATE PLAYER

function CharacterManager.updatePlayer(dt)
  player:update(dt)
end

-- UPDATE ENEMIES

function CharacterManager.updateEnemies(dt, LevelManager)
  local playerTileX, playerTileY = LevelManager.getTilePosition(player:getPosition())

  for _, enemy in ipairs(enemies) do
    if enemy:isDead() then
      CharacterManager.removeEnemy(enemy)
      table.insert(killedEnemies, enemy)
      return
    end

    enemy:update(dt)

    -- Save enemies position
    local tileX, tileY = LevelManager.getTilePosition(enemy:getPosition())
    if enemiesPosition[tileX .. "-" .. tileY] == nil then
      enemiesPosition[tileX .. "-" .. tileY] = {}
    end
    table.insert(enemiesPosition[tileX .. "-" .. tileY], enemy)

    -- Hit player if touch
    local isClose = math.abs(playerTileX - tileX) < 2 and math.abs(playerTileY - tileY) < 2
    if isClose and CollisionManager.bodyCollision(player, enemy) then
      AttackManager.PlayerHit(player, love.math.random(5, 10), enemy:getDirection())
    end
  end
end

-- ENEMIES POSITION

function CharacterManager.getSavePosition()
  return enemiesPosition
end

function CharacterManager.clearSavePosition()
  enemiesPosition = {}
end

-- DRAW KILLED ENEMIES

function CharacterManager.drawKilledEnemies()
  for _, enemy in ipairs(killedEnemies) do
    enemy:draw()
  end
end

-- DRAW PLAYER AND ENEMIES

function CharacterManager.drawPlayerAndEnemies()
  if not player:isDead() then
    for _, enemy in ipairs(enemies) do
      enemy:draw()
    end
  end

  love.graphics.setBlendMode("alpha")
  player:draw()
end

-- UPGRADE PLAYER

EventManager.addEventListener("LevelUp", function(level)
  if level % 2 == 0 then
    CharacterManager.shootFaster()
  else
    CharacterManager.shootStronger()
  end
end)

function CharacterManager.shootFaster()
  player.weapon.fireRate = math.max(player.weapon.fireRate - 0.175, 0.05)
end

function CharacterManager.shootStronger()
  player.weapon.minDamage = player.weapon.minDamage * 1.25
  player.weapon.maxDamage = player.weapon.maxDamage * 1.25
end

EventManager.addEventListener("PrevPlayerSprite", function()
  player.animation.image = PlayerAnimation.previousSprite()
end)

EventManager.addEventListener("NextPlayerSprite", function()
  player.animation.image = PlayerAnimation.nextSprite()
end)

-- GET PLAYER

function CharacterManager.getPlayer()
  return player
end

-- GET ENEMIES

function CharacterManager.getEnemies()
  return enemies
end

return CharacterManager
