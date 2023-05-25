local Sprite = require("scripts.Entities.Sprite")

local image = love.graphics.newImage("assets/images/sprites/enemies/Bat 32x32.png")
local width, height = 32, 32
local spriteWidth, spriteHeight = 64, 64

local BatAnimation = {}

function BatAnimation.new(enemyType)
  local Animation = Sprite.new(image, width, height, spriteWidth, spriteHeight)
  Animation:addAnimation("IDLE", 0, enemyType, 4, 0.3, true)
  Animation:addAnimation("MOVE", 0, enemyType, 4, 0.2, true)
  Animation:addAnimation("HURT", 3, enemyType, 4, 0.08, false)
  Animation:addAnimation("DEAD", 3, enemyType, 4, 0.08, false)
  Animation:setAnimation("IDLE")

  Animation.spriteScale = 1.5
  return Animation
end

return BatAnimation
