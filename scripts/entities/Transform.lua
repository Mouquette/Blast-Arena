local Transform = {}
Transform.__index = Transform

local Vector = require("scripts.Entities.Vector")

function Transform.new(x, y, size, angle)
  local self = setmetatable({}, Transform)

  self.position = Vector.new({ x = x, y = y })
  self.size = size
  self.angle = angle

  return self
end

return Transform
