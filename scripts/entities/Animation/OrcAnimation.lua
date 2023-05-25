local Sprite = require("scripts.Entities.Sprite")

local image = {
  love.graphics.newImage("assets/images/sprites/enemies/Orc1 64x48.png"),
  love.graphics.newImage("assets/images/sprites/enemies/Orc2 64x48.png")
}
local width, height = 64, 48
local spriteWidth, spriteHeight = 64, 48

local OrcAnimation = {}

function OrcAnimation.new(enemyType)
  local img = image[enemyType]
  local Animation = Sprite.new(img, width, height, spriteWidth, spriteHeight)
  Animation:addAnimation("IDLE", 0, 1, 4, 0.1, true)
  Animation:addAnimation("MOVE", 0, 2, 4, 0.1, true)
  Animation:addAnimation("HURT", 5, 3, 4, 0.1, false)
  Animation:addAnimation("DEAD", 5, 3, 4, 0.1, false)
  Animation:addAnimation("ATCK", 0, 3, 4, 0.1, false)
  Animation:setAnimation("IDLE")

  Animation.spriteScale = 4
  return Animation
end

return OrcAnimation
