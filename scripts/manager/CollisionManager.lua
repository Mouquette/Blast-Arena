local CollisionManager = {}

-- MODULES

local LevelManager = require("scripts.Manager.LevelManager")
local Vector = require("scripts.Entities.Vector")

-- CLAMP HELPER FUNCTION

local function clamp(min, max, value)
  return math.min(math.max(value, min), max)
end

-- TILE COLLISION

function CollisionManager.tileCollision(transform)
  local collisions = {}
  local tiles = {}
  local tileOnX, tileOnY = LevelManager.getTilePosition(transform.position.x, transform.position.y)
  local tileSize = LevelManager.getTileSize()

  for i = -2, 2, 1 do
    for j = -2, 2, 1 do
      local tileX = (tileOnX + j) - 1
      local tileY = (tileOnY + i) - 1

      if LevelManager.isTileCollision(tileX + 1, tileY + 1) then
        local dot = {}
        dot.x = clamp((tileX * tileSize), (tileX * tileSize) + tileSize, transform.position.x)
        dot.y = clamp((tileY * tileSize), (tileY * tileSize) + tileSize, transform.position.y)

        local vector = Vector.new({ x = transform.position.x - dot.x, y = transform.position.y - dot.y })
        local distance = vector:length()

        table.insert(tiles, { x = tileX, y = tileY, collision = true })
        if distance < transform.size / 2 then
          table.insert(collisions, { dot = dot, vector = vector, distance = distance })
        end
      else
        table.insert(tiles, { x = tileX, y = tileY, collision = false })
      end
    end
  end

  return collisions, tiles
end

-- BODY COLLISION

function CollisionManager.bodyCollision(bodyA, bodyB)
  local charA_X = bodyA.transform.position.x
  local charA_Y = bodyA.transform.position.y
  local charA_Size = bodyA.transform.size / 2

  local charB_X = bodyB.transform.position.x
  local charB_Y = bodyB.transform.position.y
  local charB_Size = bodyB.transform.size / 2

  local vector = Vector.new({ x = charA_X - charB_X, y = charA_Y - charB_Y })
  local distance = vector:length()

  if distance < charA_Size + charB_Size then
    return true
  else
    return false
  end
end

return CollisionManager
