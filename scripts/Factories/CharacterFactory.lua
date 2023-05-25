local CharacterFactory = {}
local Character = require("scripts.Entities.Character")

-- AGENTS

local PlayerController = require("scripts.Entities.Agent.PlayerAgent")
local KamikazeAgent = require("scripts.Entities.Agent.KamikazeAgent")
local MeleeAgent = require("scripts.Entities.Agent.MeleeAgent")

-- ANIMATIONS

local PlayerAnimation = require("scripts.Entities.Animation.PlayerAnimation")
local BatAnimation = require("scripts.Entities.Animation.BatAnimation")
local SnakeAnimation = require("scripts.Entities.Animation.SnakeAnimation")
local EnemyBoxAnimation = require("scripts.Entities.Animation.EnemyBoxAnimation")
local HumanAnimation = require("scripts.Entities.Animation.HumanAnimation")
local SkeletonAnimation = require("scripts.Entities.Animation.SkeletonAnimation")
local OrcAnimation = require("scripts.Entities.Animation.OrcAnimation")

-- WEAPONS

local WeaponManager = require("scripts.Factories.WeaponFactory")

-- CREATE PLAYER

local player = nil
function CharacterFactory.createPlayer(x, y)
  local data = { x = x, y = y, size = 64, speed = 500 }
  player = Character.new(data, 100)
  player.controller = PlayerController.new(player)
  player.animation = PlayerAnimation.new()
  player.weapon = WeaponManager.createGun()
  player:setShadow(0, 0)

  return player
end

-- CREATE BAT

function CharacterFactory.createBat(x, y)
  local data = { x = x, y = y, size = 64, speed = 250 }
  local enemy = Character.new(data, 5)
  enemy.controller = KamikazeAgent.new(enemy, player)

  local enemyType = love.math.random(0, 3)
  enemy.animation = BatAnimation.new(enemyType)
  enemy:setShadow(0, 2)

  return enemy
end

-- CREATE SNAKE

function CharacterFactory.createSnake(x, y)
  local data = { x = x, y = y, size = 64, speed = 450 }
  local enemy = Character.new(data, 10)
  enemy.controller = KamikazeAgent.new(enemy, player)

  local enemyType = love.math.random(0, 1)
  enemy.animation = SnakeAnimation.new(enemyType)
  enemy:setShadow(-4, -11)

  return enemy
end

-- CREATE ENEMY BOX

function CharacterFactory.createEnemyBox(x, y)
  local data = { x = x, y = y, size = 64, speed = 250 }
  local enemy = Character.new(data, 20)
  enemy.controller = MeleeAgent.new(enemy, player)
  enemy.weapon = WeaponManager.createMelee(64, 0.5, 10, 15)

  local enemyType = love.math.random(1, 3)
  enemy.animation = EnemyBoxAnimation.new(enemyType)
  enemy:setShadow(0, 0)

  return enemy
end

-- CREATE HUMAN

function CharacterFactory.createHuman(x, y)
  local data = { x = x, y = y, size = 64, speed = 300 }
  local enemy = Character.new(data, 50)
  enemy.controller = MeleeAgent.new(enemy, player)
  enemy.weapon = WeaponManager.createMelee(64, 0.5, 10, 15)

  local enemyType = love.math.random(1, 3)
  enemy.animation = HumanAnimation.new(enemyType)
  enemy:setShadow(0, 6)

  return enemy
end

-- CREATE SKELETON

function CharacterFactory.createSkeleton(x, y)
  local data = { x = x, y = y, size = 64, speed = 200 }
  local enemy = Character.new(data, 15)
  enemy.controller = MeleeAgent.new(enemy, player)
  enemy.weapon = WeaponManager.createMelee(64, 0.5, 10, 15)

  local enemyType = love.math.random(1, 2)
  enemy.animation = SkeletonAnimation.new(enemyType)
  enemy:setShadow(0, 6)

  return enemy
end

-- CREATE ORC

function CharacterFactory.createOrc(x, y)
  local data = { x = x, y = y, size = 110, speed = 150 }
  local enemy = Character.new(data, 100)
  enemy.controller = MeleeAgent.new(enemy, player)

  local enemyType = love.math.random(1, 2)
  enemy.animation = OrcAnimation.new(enemyType)
  enemy.weapon = WeaponManager.createMelee(90, 0.5, 15, 30)
  enemy:setShadow(0, 6)

  return enemy
end

return CharacterFactory
