local WaveManager = {}

local EventManager = require("scripts.Manager.EventManager")
local CharacterFactory = require("scripts.Factories.CharacterFactory")

local kills = 0
local level = 1
local wave = 1
local WaveLevels = { 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 }

EventManager.addEventListener("keypressed", function(key)
  if key == "kp0" and (DEMO_MODE or DEBUG_MODE) then
    level = math.min(level + 1, #WaveLevels)
    EventManager.dispatch("LevelUp", level)
  end
end)

local enemyFactories = {
  CharacterFactory.createBat,
  CharacterFactory.createSkeleton,
  CharacterFactory.createEnemyBox,
  CharacterFactory.createSnake,
  CharacterFactory.createHuman,
  CharacterFactory.createOrc
}

WaveManager.reset = function(x, y)
  kills = 0
  level = 1
  wave = 1
end

WaveManager.createEnemy = function(x, y)
  local randMax = math.min(level, #enemyFactories)
  local enemyFactory = enemyFactories[love.math.random(1, randMax)]
  return enemyFactory(x, y)
end

WaveManager.getWaveSpawnSpeed = function(x, y)
  return 0.6 - (0.05 * level)
end

WaveManager.getKills = function()
  return kills
end

EventManager.addEventListener("EnemyKilled", function()
  kills = kills + 1

  if level > #WaveLevels then
    return
  end

  wave = wave + 1
  if wave > WaveLevels[level] then
    level = level + 1
    EventManager.dispatch("LevelUp", level)
    wave = 1
  end
end)

return WaveManager
