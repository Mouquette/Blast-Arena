local ZaWarudo = {}

local EventManager = require("scripts.Manager.EventManager")

local power = 0
local powerMax = 50
local powerTime = 0
local feedbackReady = true
local feedbackAlmostFinish = true

EventManager.addEventListener("EnemyKilled", function()
  if not ZaWarudo.inProgress() and power < powerMax then
    power = power + 1
  elseif power == powerMax and feedbackReady then
    feedbackReady = false
    EventManager.dispatch("powerReady")
  end

  EventManager.dispatch("powerPercent", power / powerMax)
end)

function ZaWarudo.reset()
  power = 0
  powerMax = 30
  powerTime = 0
  feedbackReady = true
end

function ZaWarudo.update(dt)
  if not ZaWarudo.inProgress() then
    return
  end

  powerTime = powerTime - dt

  if powerTime <= 0 then
    powerTime = 0
    feedbackAlmostFinish = true
    EventManager.dispatch("powerFinish")
  elseif powerTime < 3 and feedbackAlmostFinish then
    EventManager.dispatch("powerAlmostFinish", powerTime / 6)
    feedbackAlmostFinish = false
  end
end

function ZaWarudo.use()
  power = 0
  powerTime = 6
  powerMax = powerMax + 10
  feedbackReady = true
  EventManager.dispatch("powerStart")
end

function ZaWarudo.ready()
  return power == powerMax
end

function ZaWarudo.inProgress()
  return powerTime > 0
end

return ZaWarudo
