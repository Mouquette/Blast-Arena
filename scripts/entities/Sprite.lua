local Sprite = {}
Sprite.__index = Sprite

function Sprite.new(image, width, height, spriteWidth, spriteHeight)
  local self = setmetatable({}, Sprite)

  self.image = image
  self.canvas = love.graphics.newCanvas(spriteWidth, spriteHeight or spriteWidth)

  self.width = width
  self.height = height

  self.spriteWidth = spriteWidth
  self.spriteHeight = spriteHeight

  self.scaleX = spriteWidth / width
  self.scaleY = spriteHeight / height
  self.spriteScale = 1

  self.animations = {}
  self.currentAnimation = nil
  self.currentFrame = 1
  self.currentTime = 0

  return self
end

function Sprite:addAnimation(name, line, column, frames, duration, loop)
  local quads = {}
  for i = 0, frames do
    local x = line * self.width + self.width * i
    local y = column * self.height
    table.insert(quads, love.graphics.newQuad(x, y, self.width, self.height, self.image:getDimensions()))
  end

  self.animations[name] = { quads = quads, duration = duration, loop = loop }
end

function Sprite:setAnimation(name)
  if self.animations[name] ~= nil then
    self.currentAnimation = self.animations[name]
    self.currentFrame = 1
    self.currentTime = 0
    self:updateSprite()
  end
end

function Sprite:updateSprite()
  self.canvas:renderTo(function()
    love.graphics.clear()
    love.graphics.draw(self.image, self.currentAnimation.quads[self.currentFrame], 0, 0, 0, self.scaleX, self.scaleY)
  end)
end

function Sprite:updateFrame()
  self.currentFrame = self.currentFrame + 1
  if self.currentFrame == #self.currentAnimation.quads then
    self.currentFrame = self.currentAnimation.loop and 1 or #self.currentAnimation.quads - 1
  end
end

function Sprite:update(dt)
  if self.currentAnimation == nil then
    return
  end

  self.currentTime = self.currentTime + dt
  if self.currentTime >= self.currentAnimation.duration then
    self.currentTime = self.currentTime - self.currentAnimation.duration

    self:updateFrame()
    self:updateSprite()
  end
end

function Sprite:getSprite()
  return self.canvas
end

function Sprite:getSpriteSize()
  return self.spriteWidth, self.spriteHeight
end

function Sprite:getOrigin()
  return self.spriteWidth / 2, self.spriteHeight / 2
end

return Sprite
