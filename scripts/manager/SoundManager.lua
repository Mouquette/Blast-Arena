local SoundManager = {}

local EventManager = require("scripts.Manager.EventManager")

-- BGM

local MenuBGM = love.audio.newSource("assets/sounds/bgm/MainMenu.mp3", "stream")
local GameBGM = love.audio.newSource("assets/sounds/bgm/GameBGM.mp3", "stream")

SoundManager.bgmMute = false
SoundManager.bgmVolume = SoundManager.bgmMute and 0 or 0.75

EventManager.addEventListener("playGame", function()
  GameBGM:setVolume(SoundManager.bgmVolume * 0.5)
  GameBGM:setLooping(true)
  GameBGM:play()
end)

EventManager.addEventListener("pauseGame", function()
  GameBGM:setVolume(SoundManager.bgmVolume * 0.05)
end)

EventManager.addEventListener("powerStart", function()
  GameBGM:pause()
end)

EventManager.addEventListener("powerFinish", function()
  GameBGM:play()
end)

-- SFX

local MeleeSound = love.audio.newSource("assets/sounds/sfx/Melee.wav", "static")
local GunSound = love.audio.newSource("assets/sounds/sfx/Shoot.wav", "static")
local HitSound = love.audio.newSource("assets/sounds/sfx/Hit.wav", "static")
local KillSound = love.audio.newSource("assets/sounds/sfx/Kill.wav", "static")
local DashSound = love.audio.newSource("assets/sounds/sfx/Dash.wav", "static")
local HurtSound = love.audio.newSource("assets/sounds/sfx/Hurt.wav", "static")
local DeathSound = love.audio.newSource("assets/sounds/sfx/Death.wav", "static")
local LevelUpSound = love.audio.newSource("assets/sounds/sfx/LevelUp.wav", "static")
local PowerReady = love.audio.newSource("assets/sounds/sfx/PowerReady.wav", "static")
local ZaWarudo = love.audio.newSource("assets/sounds/sfx/ZaWarudo.wav", "static")
local ZaWarudoReverse = love.audio.newSource("assets/sounds/sfx/ZaWarudo Reverse.mp3", "static")

SoundManager.sfxMute = false
SoundManager.sfxVolume = SoundManager.sfxMute and 0 or 0.75

EventManager.addEventListener("Shoot", function()
  local sound = GunSound:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

EventManager.addEventListener("Melee", function()
  local sound = MeleeSound:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

EventManager.addEventListener("Hit", function()
  local sound = HitSound:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

EventManager.addEventListener("EnemyKilled", function()
  local sound = KillSound:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

EventManager.addEventListener("PlayerDash", function()
  local sound = DashSound:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

EventManager.addEventListener("Hurt", function()
  local sound = HurtSound:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

EventManager.addEventListener("Death", function()
  GameBGM:stop()

  local sound = DeathSound:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

EventManager.addEventListener("LevelUp", function()
  local sound = LevelUpSound:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

EventManager.addEventListener("powerReady", function()
  local sound = PowerReady:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

EventManager.addEventListener("powerStart", function()
  local sound = ZaWarudo:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

EventManager.addEventListener("powerAlmostFinish", function()
  local sound = ZaWarudoReverse:clone()
  sound:setVolume(SoundManager.sfxVolume)
  sound:play()
end)

