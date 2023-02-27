local Game = require("game")

local Gun = {}
local reloadKey = "space"
local shootButton = 1

function Gun:load()
	self.ammoCap = 6
	self.ammo = self.ammoCap
	self.reloadKeyDown = 0
	self.reloadDuration = 0.5
	self.inCoolDown = false
	self.coolDownDuration = 0.3
	self.coolDownTime = 0
end

--[[ 
-- Shooting is handled by mouse clicks.
-- The player cannot shoot while reloading or when out of ammo.
-- If the player hits the target, the score is incremented
-- Every time the player shoots the ammo counter is decremented
]]--
function Gun:playerCanShoot(button)
	if button == shootButton and self.ammo > 0
			and self.reloading == false and self.inCoolDown == false then
		return true
	end
	return false
end

function Gun:shoot( x, y, button)
	if self:playerCanShoot(button) then
		Game:checkHit(x, y)
		self.ammo = self.ammo - 1
		self.inCoolDown = true
		self.coolDownTime = self.coolDownDuration
	end
end

--[[
-- Reloading is dynamic, the gun is a revolver so bullets are placed into the chamber
-- one by one. The total reload time is calculated when the reload button is pressed
-- and the ammo counter then starts gradually incrementing. The reload action can be
-- cancelled by pressing the button again and then the player can continue shooting
-- with a partially empty gun
]]--
function Gun:reload(dt)
	if self.reloading and self.ammo < self.ammoCap then
		self.reloadKeyDown = self.reloadKeyDown + dt
		if self.reloadKeyDown >= self.reloadDuration then
			self.ammo = self.ammo + 1
			self.reloadKeyDown = 0
		end
	end
end

-- to add some realism there is a slight cool down between each shot
function Gun:decreaseCoolDown(dt)
	if self.inCoolDown then
		self.coolDownTime = self.coolDownTime - dt
		if self.coolDownTime <= 0 then
			self.inCoolDown = false
		end
	end
end

function Gun:update(dt)
	self:reload(dt)
	self:decreaseCoolDown(dt)
	self.reloading = love.keyboard.isDown("space")
end

function Gun:draw()
	love.graphics.print("Ammo:", 250, 0)
	love.graphics.print(self.ammo, 400, 2)
end

return Gun
