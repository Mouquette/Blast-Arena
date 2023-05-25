-- Blast Arena Game
-- Version 0.1.0
love.mouse.setVisible(false)
love.graphics.setDefaultFilter("nearest", "nearest")

local EventManager = require("scripts.Manager.EventManager")
local SoundManager = require("scripts.Manager.SoundManager")

local cursor = love.graphics.newImage("assets/images/sprites/crosshair/crosshair.png")
local cursorOriginX = cursor:getWidth() / 2
local cursorOriginY = cursor:getHeight() / 2

local currentScene = require("scripts.Scenes.GameScene")

function love.load()
  currentScene.load()
end

function love.update(dt)
  dt = math.min(dt, 1 / 60)
  currentScene.update(dt)
end

function love.draw()
  currentScene.draw()

  love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY(), 0, 1.2, 1.2, cursorOriginX, cursorOriginY)

  if DEBUG_MODE then
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.print("FPS: " .. love.timer.getFPS(), 12, love.graphics.getHeight() - 30)
  end
end

function love.keypressed(key)
  EventManager.dispatch("keypressed", key)

  if DEMO_MODE then
    if key == "kp-" then
      EventManager.dispatch("PrevPlayerSprite")
    elseif key == "kp+" then
      EventManager.dispatch("NextPlayerSprite")
    end
  end
end
