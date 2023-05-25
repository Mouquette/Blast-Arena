local GameManager = {}

-- MODULES

local EventManager = require("scripts.Manager.EventManager")
local LevelManager = require("scripts.Manager.LevelManager")
local CameraManager = require("scripts.Manager.CameraManager")
local AttackManager = require("scripts.Manager.AttackManager")
local CharacterManager = require("scripts.Manager.CharacterManager")
local WaveManager = require("scripts.Manager.WaveManager")
local ZaWarudo = require("scripts.Manager.ZaWarudo")
local Vector = require("scripts.Entities.Vector")

-- EVENTS

local cameraFocusPoint = Vector.new({ x = 0, y = 0 })
EventManager.addEventListener("shakeCamera", function(force, time)
  CameraManager.shake(force, time)
end)

-- LOAD
local time = 0

function GameManager.load()
  LevelManager.load()
  CameraManager.initialize()
  GameManager.reset()
end

function GameManager.reset()
  time = 0
  ZaWarudo.reset()
  WaveManager.reset()
  AttackManager.reset()
  CameraManager.setFocus(cameraFocusPoint)
  CharacterManager.initialize(LevelManager)
end

function GameManager.getKillAndTime()
  local minutes = math.floor(time / 60)
  local seconds = math.floor(time % 60)
  local stringTime = string.format("%02.0f:%02.0f", minutes, seconds)
  return WaveManager.getKills(), stringTime
end

function GameManager.update(dt)
  -- Clear
  CharacterManager.clearSavePosition()
  CharacterManager.clearKilledEnemies(dt)

  -- Za Warudo
  if not CharacterManager.getPlayer():isDead() then
    if love.keyboard.isDown("space") and ZaWarudo.ready() then
      ZaWarudo.use()
    end
    ZaWarudo.update(dt)
  end

  if CharacterManager.getPlayer():isDead() or ZaWarudo.inProgress() then
    CharacterManager.updatePlayer(dt)
  else
    time = time + dt

    -- Spawn and move
    CharacterManager.spawnEnemy(dt, LevelManager)
    CharacterManager.updatePlayer(dt)
    CharacterManager.updateEnemies(dt, LevelManager)

    -- Attacks
    AttackManager.updatePlayerAttack(dt, CharacterManager.getSavePosition())
    AttackManager.updateEnemiesAttack(dt, CharacterManager.getPlayer())
  end

  -- Camera Update
  local playerX, playerY = CharacterManager.getPlayer():getPosition()
  if CharacterManager.getPlayer():isDead() then
    cameraFocusPoint.x = playerX
    cameraFocusPoint.y = playerY
  else
    local mouseX, mouseY = love.mouse.getPosition()
    local camCenterX, camCenterY = CameraManager.getCameraCenter()
    cameraFocusPoint.x = playerX + (mouseX - camCenterX) * 0.4
    cameraFocusPoint.y = playerY + (mouseY - camCenterY) * 0.4
  end
  CameraManager.update(dt)
end

function GameManager.draw()
  CameraManager.render(function()
    if ZaWarudo.inProgress() then
      love.graphics.setBackgroundColor(1, 1, 1)
      love.graphics.setBlendMode("subtract")
    else
      love.graphics.setBackgroundColor(81 / 255, 222 / 255, 0)
      love.graphics.setBlendMode("alpha")
    end
    LevelManager.draw()
    if not CharacterManager.getPlayer():isDead() then
      CharacterManager.drawKilledEnemies()
      AttackManager.drawAttacks()
    end
    CharacterManager.drawPlayerAndEnemies()
  end)
end

return GameManager
