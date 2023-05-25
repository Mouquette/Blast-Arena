local GameScene = {}

-- MODULES

local EventManager = require("scripts.Manager.EventManager")
local GameManager = require("scripts.Manager.GameManager")

-- UI

local Bars = require("scripts.UI.Bars")
local Icons = require("scripts.UI.Icons")

-- GAME STATE

local STATES = { GAME = 1, PAUSE = 2, END = 3 }
local currentState = STATES.GAME
local endTimer = 0

local function pauseGame()
  currentState = STATES.PAUSE
end

local function playGame()
  currentState = STATES.GAME
end

local function gameOver()
  endTimer = 1.5
  currentState = STATES.END
end

EventManager.addEventListener("keypressed", function(key)
  if key == "escape" then
    if currentState == STATES.GAME then
      EventManager.dispatch("pauseGame")
    elseif currentState == STATES.PAUSE then
      EventManager.dispatch("playGame")
    end
  end
end)

function GameScene.load()
  currentState = STATES.GAME
  GameManager.load()

  EventManager.addEventListener("pauseGame", pauseGame)
  EventManager.addEventListener("playGame", playGame)
  EventManager.addEventListener("Death", gameOver)

  EventManager.dispatch("playGame")
end

function GameScene.update(dt)
  GameManager.getKillAndTime()

  if currentState == STATES.END then
    endTimer = endTimer - dt
    if endTimer > 0 then
      GameManager.update(dt)
    elseif love.keyboard.isDown("space") then
      Bars.reset()
      GameManager.reset()
      EventManager.dispatch("playGame")
    end
  elseif currentState == STATES.GAME then
    GameManager.update(dt)
  end
end

function GameScene.draw()
  GameManager.draw()
  Bars.draw()

  local kills, time = GameManager.getKillAndTime()
  Icons.draw(kills, time)

  if currentState == STATES.PAUSE then
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.printf("PAUSE", 0, love.graphics.getHeight() / 2 - 20, love.graphics.getWidth(), "center")
  end

  if currentState == STATES.END and endTimer <= 0 then
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(64))
    love.graphics.printf("GAME OVER", 0, love.graphics.getHeight() / 2 - 175, love.graphics.getWidth(), "center")

    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.printf("Kills: ", -150, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
    love.graphics.printf(tostring(kills), -70, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
    love.graphics.printf("Time: ", 50, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
    love.graphics.printf(time, 150, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")

    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.printf("PRESS SPACE TO RETRY", 0, love.graphics.getHeight() / 2 + 50, love.graphics.getWidth(),
                         "center")
  end
end

return GameScene
