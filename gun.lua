local Game = require("game")
local Gun = {}


function Gun:load()
	love.mouse.setVisible(false)
	self.ammoCap = 6
	self.ammo = self.ammoCap
	self.reloadKeyDown = 0
	self.reloadDuration = 0.5
	self.aimTime = 0
	self.aimLimit = 2 
	self.inShotCoolDown = false
	self.shotCoolDownDuration = 0.3
	self.shotCoolDownTime = 0
end

--[[ 
-- Shooting is handled by mouse clicks.
-- The player cannot shoot while reloading or when out of ammo.
-- If the player hits the target, the score is incremented
-- Every time the player shoots the ammo counter is decremented
]]--
function Gun:playerCanShoot(button)
	if button == Keys.shootButton and self.ammo > 0
			and self.reloading == false and self.inShotCoolDown == false then
		return true
	end
	return false
end

function Gun:aim(dt)
	if self.aiming == true and self.aimTime <= self.aimLimit then
		love.mouse.setVisible(true)
		self.aimTime = self.aimTime + dt
		if self.aimTime >= self.aimLimit then
			self.aiming = false
		end
	else
		love.mouse.setVisible(false)
	end
end

function Gun:shoot( x, y, button)
	if self:playerCanShoot(button) then
		Game:checkHit(x, y)
		self.ammo = self.ammo - 1
		self.inShotCoolDown = true
		self.shotCoolDownTime = self.shotCoolDownDuration
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
	if self.reloading and self.ammo < self.ammoCap and self.aiming == false then
		self.reloadKeyDown = self.reloadKeyDown + dt
		if self.reloadKeyDown >= self.reloadDuration then
			self.ammo = self.ammo + 1
			self.reloadKeyDown = 0
		end
	end
end

-- to add some realism there is a slight cool down between each shot
function Gun:decreaseShotCoolDown(dt)
	if self.inShotCoolDown then
		self.shotCoolDownTime = self.shotCoolDownTime - dt
		if self.shotCoolDownTime <= 0 then
			self.inShotCoolDown = false
		end
	end
end

function Gun:decreaseAimTime(dt)
	if self.aiming == false and self.aimTime > 0 then
		self.aimTime = self.aimTime - (1.5 * dt)
	end
end

function Gun:update(dt)
	self:reload(dt)
	self:decreaseShotCoolDown(dt)
	self:decreaseAimTime(dt)
	self.reloading = love.keyboard.isDown(Keys.reloadKey)
	self:aim(dt)
	self.aiming = love.mouse.isDown(Keys.aimButton)
end

function Gun:draw()
end

return Gun
