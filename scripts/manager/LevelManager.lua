local LevelManager = {}

local Map = require("map.map")
local MapCanvas = love.graphics.newCanvas(Map.width * Map.tilewidth, Map.height * Map.tileheight)

local Tileset = {}
local TilesetImage = love.graphics.newImage("assets/images/tiles/tileset.png")

local rows = TilesetImage:getHeight() / Map.tilewidth
local col = TilesetImage:getWidth() / Map.tileheight
for i = 1, rows do
  for j = 1, col do
    local quadX, quadY = (j - 1) * Map.tilewidth, (i - 1) * Map.tileheight
    local tile = love.graphics.newQuad(quadX, quadY, Map.tilewidth, Map.tileheight, TilesetImage:getDimensions())
    table.insert(Tileset, tile)
  end
end

function LevelManager.load()
  love.graphics.setCanvas(MapCanvas)
  for _, layer in ipairs(Map.layers) do
    for i = 1, layer.height do
      for j = 1, layer.width do
        local t = layer.width * (i - 1) + j
        local tile = layer.data[t]

        if tile ~= 0 then
          local x = (j - 1) * Map.tilewidth
          local y = (i - 1) * Map.tileheight
          love.graphics.draw(TilesetImage, Tileset[tile], x, y)
        end
      end
    end
  end
  love.graphics.setCanvas()
end

function LevelManager.getMapSize()
  return Map.width * Map.tilewidth, Map.height * Map.tileheight
end

function LevelManager.getTileSize()
  return Map.tilewidth
end

function LevelManager.getTilePosition(x, y)
  return math.floor(x / Map.tilewidth) + 1, math.floor(y / Map.tileheight) + 1
end

function LevelManager.isTileCollision(x, y)
  local layer = Map.layers[3]
  return layer.data[layer.width * (y - 1) + x] ~= 0
end

function LevelManager.draw()
  love.graphics.draw(MapCanvas)
end

return LevelManager
