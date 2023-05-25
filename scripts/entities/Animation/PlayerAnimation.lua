local Sprite = require("scripts.Entities.Sprite")

local images = {
  love.graphics.newImage("assets/images/sprites/player/character_20x20_black.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_blue.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_brown.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_cyan.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_green.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_lime.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_orange.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_pink.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_purple.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_red.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_white.png"),
  love.graphics.newImage("assets/images/sprites/player/character_20x20_yellow.png")
}

local currentSprite = 5
local image = images[5]
local width, height = 20, 20
local spriteWidth, spriteHeight = 64, 64

local PlayerAnimation = {}

function PlayerAnimation.new()
  local Animation = Sprite.new(image, width, height, spriteWidth, spriteHeight)
  Animation:addAnimation("IDLE", 0, 0, 4, 0.1, true)
  Animation:addAnimation("MOVE", 0, 1, 6, 0.1, true)
  Animation:addAnimation("HURT", 0, 3, 2, 0.2, false)
  Animation:addAnimation("DEAD", 0, 4, 6, 0.1, false)
  Animation:setAnimation("IDLE")

  return Animation
end

function PlayerAnimation.getSprite()
  return images[currentSprite]
end

function PlayerAnimation.previousSprite()
  currentSprite = currentSprite - 1
  if currentSprite < 1 then
    currentSprite = #images
  end
  return PlayerAnimation.getSprite()
end

function PlayerAnimation.nextSprite()
  currentSprite = currentSprite + 1
  if currentSprite > #images then
    currentSprite = 1
  end
  return PlayerAnimation.getSprite()
end

return PlayerAnimation
