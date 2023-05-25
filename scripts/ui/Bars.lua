local Bars = {}

local EventManager = require("scripts.Manager.EventManager")

local barsBG = love.graphics.newImage("assets/images/ui/bars_bg.png")
local barsColors = love.graphics.newImage("assets/images/ui/bars_color.png")

local redBar = love.graphics.newQuad(0, 0, 3, 3, barsColors:getDimensions())
local orangeBar = love.graphics.newQuad(3, 0, 3, 3, barsColors:getDimensions())
local blueBar = love.graphics.newQuad(6, 0, 3, 3, barsColors:getDimensions())
local greenBar = love.graphics.newQuad(9, 0, 3, 3, barsColors:getDimensions())

local barScale = 2.5

local lifePercent = 1
EventManager.addEventListener("playerLifePercent", function(percent)
  lifePercent = percent
end)

local powerPercent = 0
EventManager.addEventListener("powerPercent", function(percent)
  powerPercent = percent
end)

function Bars.reset()
  lifePercent = 1
  powerPercent = 0
end

function Bars.draw()
  love.graphics.draw(barsBG, 10, 10, 0, barScale, barScale)
  love.graphics.draw(barsColors, redBar, 14, 15, 0, (barsBG:getWidth() - 3) / 3 * barScale * lifePercent, barScale)
  love.graphics.draw(barsColors, blueBar, 14, 38, 0, (barsBG:getWidth() - 35) / 3 * barScale * powerPercent, barScale)
end

return Bars
