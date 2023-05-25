local CameraManager = {}
local Camera = {}

local Vector = require("scripts.Entities.Vector")

function CameraManager.initialize()
  local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

  Camera.x = 0
  Camera.y = 0
  Camera.width = screenWidth
  Camera.height = screenHeight
  Camera.centerX = Camera.width / 2
  Camera.centerY = Camera.height / 2

  Camera.focusPoint = Vector.new({ x = 0, y = 0 })
  Camera.currentPoint = Vector.new({ x = 0, y = 0 })

  Camera.shakeTimer = 0
  Camera.shakeForce = 0
  Camera.shaking = { x = 0, y = 0 }
end

function CameraManager.setFocus(focusPoint)
  if type(focusPoint) == "table" and focusPoint.x ~= nil and focusPoint.y ~= nil then
    Camera.focusPoint = focusPoint
  else
    Camera.focusPoint = Vector.new({ x = 0, y = 0 })
  end
end

function CameraManager.getCameraWorldPosition()
  if Camera == nil or Camera.focusPoint == nil then
    return 0, 0
  end

  return Camera.focusPoint.x - Camera.centerX, Camera.focusPoint.y - Camera.centerY
end

function CameraManager.getCameraCenter()
  return Camera.centerX, Camera.centerY
end

function CameraManager.getMouseWorldPosition()
  local mouseX, mouseY = love.mouse.getPosition()
  return Camera.focusPoint.x + mouseX - Camera.centerX, Camera.focusPoint.y + mouseY - Camera.centerY
end

function CameraManager.shake(force, time)
  Camera.shakeForce = force
  Camera.shakeTimer = time
end

function CameraManager.update(dt)
  Camera.currentPoint.x = Camera.currentPoint.x + (Camera.focusPoint.x - Camera.currentPoint.x) * 0.1
  Camera.currentPoint.y = Camera.currentPoint.y + (Camera.focusPoint.y - Camera.currentPoint.y) * 0.1

  if Camera.shakeTimer <= 0 then
    return
  end

  Camera.shaking = {
    x = love.math.random(-Camera.shakeForce, Camera.shakeForce),
    y = love.math.random(-Camera.shakeForce, Camera.shakeForce)
  }
  Camera.shakeTimer = Camera.shakeTimer - dt
end

function CameraManager.render(cameraRender)
  love.graphics.push()
  if Camera.shakeTimer > 0 then
    love.graphics.translate(Camera.shaking.x, Camera.shaking.y)
  end

  -- Center camera + Follow the focus point
  love.graphics.translate(Camera.centerX, Camera.centerY)
  love.graphics.translate(-Camera.currentPoint.x, -Camera.currentPoint.y)

  cameraRender()

  love.graphics.pop()
end

return CameraManager
