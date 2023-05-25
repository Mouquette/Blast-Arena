local WeaponFactory = {}

-- MODULES

local AttackFactory = require("scripts.Factories.AttackFactory")
local Weapon = require("scripts.Entities.Weapon")

-- MELEE

function WeaponFactory.createMelee(radius, fireRate, minDamage, maxDamage)
  local meleeData = {
    radius = radius or 32,
    fireRate = fireRate or 0.5,
    minDamage = minDamage or 10,
    maxDamage = maxDamage or 20,
    attackModule = AttackFactory.meleeAttack
  }
  return Weapon.new(meleeData, nil)
end

-- GUN

local gunImage = love.graphics.newImage("assets/images/sprites/weapons/gun.png")
function WeaponFactory.createGun()
  local gunData = { radius = 28, fireRate = 0.6, minDamage = 5, maxDamage = 10, attackModule = AttackFactory.gunBullet }
  return Weapon.new(gunData, gunImage)
end

return WeaponFactory
