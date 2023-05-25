local Vector = {}
Vector.__index = Vector

-- Create new vector
-- @param p1 First point or vector
-- @param p2 Second point or vector (optional)
function Vector.new(p1, p2)
  local self = setmetatable({}, Vector)

  if p2 == nil then
    self.x = p1.x
    self.y = p1.y
  else
    self.x = p2.x - p1.x
    self.y = p2.y - p1.y
  end

  return self
end

function Vector:sqrLentgth()
  return self.x * self.x + self.y * self.y
end

function Vector:length()
  return math.sqrt(self:sqrLentgth())
end

function Vector:normalize()
  return self / self:length()
end

function Vector:__add(value)
  if type(value) == "number" then
    return Vector.new({ x = self.x + value, y = self.y + value })
  elseif type(value) == "table" and value.x ~= nil and value.y ~= nil then
    return Vector.new({ x = self.x + value.x, y = self.y + value.y })
  end
end

function Vector:__sub(value)
  if type(value) == "number" then
    return Vector.new({ x = self.x - value, y = self.y - value })
  elseif type(value) == "table" and value.x ~= nil and value.y ~= nil then
    return Vector.new({ x = self.x - value.x, y = self.y - value.y })
  end
end

function Vector:__mul(value)
  if type(value) == "number" then
    return Vector.new({ x = self.x * value, y = self.y * value })
  elseif type(value) == "table" and value.x ~= nil and value.y ~= nil then
    return Vector.new({ x = self.x * value.x, y = self.y * value.y })
  end
end

function Vector:__div(value)
  if type(value) == "number" then
    return Vector.new({ x = self.x / value, y = self.y / value })
  elseif type(value) == "table" and value.x ~= nil and value.y ~= nil then
    return Vector.new({ x = self.x / value.x, y = self.y / value.y })
  end
end

function Vector:__eq(value)
  if type(value) == "table" and value.x ~= nil and value.y ~= nil then
    return self.x == value.x and self.y == value.y
  end
end

function Vector:__lt(value)
  if type(value) == "table" and value.x ~= nil and value.y ~= nil and value.sqrLentgth ~= nil then
    return self:sqrLentgth() < value:sqrLentgth()
  end
end

function Vector:__le(value)
  if type(value) == "table" and value.x ~= nil and value.y ~= nil and value.sqrLentgth ~= nil then
    return self:sqrLentgth() <= value:sqrLentgth()
  end
end

function Vector:__tostring()
  return "{ x = " .. self.x .. ", y = " .. self.y .. " }"
end

return Vector
