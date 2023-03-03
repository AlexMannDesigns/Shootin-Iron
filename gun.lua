local Game = require("game")
local Colours = require("colours")

local Gun = {}
local lg = love.graphics
local alpha = 1

function Gun:load()
	self.ammoCap = 6
	self.ammo = self.ammoCap
	self.reloadKeyDown = 0
	self.reloadDuration = 0.5
	self.aimTime = 0
	self.aimLimit = 2
	self.aimRadius = 100
	self.inShotCoolDown = false
	self.shotCoolDownDuration = 0.3
	self.shotCoolDownTime = 0
	self.recoil = 50
	self.bulletX = 0
	self.bulletY = 0
	self.bulletHoleVisible = false
	self.bulletHoleTimeLimit = 2
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
		self.aimTime = self.aimTime + dt
		if self.aimTime >= self.aimLimit then
			self.aiming = false
		end
	end
end

function Gun:randomiseShot(x, y)
	local randomX
	local randomY

	print(self:currentAimRadius())
	randomX = x + math.floor(math.random(0 - self:currentAimRadius() * 0.9, self:currentAimRadius() * 0.9))
	randomY = y + math.floor(math.random(0 - self:currentAimRadius() * 0.9, self:currentAimRadius() * 0.9))
	return randomX, randomY
end

function Gun:shoot(x, y, button)
	if self:playerCanShoot(button) then
		self.bulletX, self.bulletY = self:randomiseShot(x, y)
		self.bulletHoleVisible = true
		self.bulletHoleTime = self.bulletHoleTimeLimit
	--  print("bullet x: ", self.bulletX, "actual x: ", x, self.bulletX < x) --"bullet y:", self.bulletY, "actual y: ", y)
		Game:checkHit(self.bulletX, self.bulletY)
	--[[	if y - self.recoil < 0 then
			love.mouse.setPosition(x, 0)
		else
			love.mouse.setPosition(x, y - self.recoil)
		end]]--
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

function Gun:decreaseBulletHoleTime(dt)
	if self.bulletHoleVisible and self.bulletHoleTime > 0 then
		self.bulletHoleTime = self.bulletHoleTime - dt
	elseif self.bulletHoleVisible then
		self.bulletHoleVisible = false
	end
end

function Gun:update(dt)
	self:reload(dt)
	self:decreaseShotCoolDown(dt)
	self:decreaseBulletHoleTime(dt)
	self:decreaseAimTime(dt)
	self.reloading = love.keyboard.isDown(Keys.reloadKey)
	self:aim(dt)
	self.aiming = love.mouse.isDown(Keys.aimButton)
end
	
function Gun:currentAimRadius()
	if self.aiming and self.aimTime < self.aimLimit then
		return math.floor(self.aimRadius * (1 - (self.aimTime / self.aimLimit)))
	end
	return self.aimRadius
end

function Gun:drawBulletHole()
	Colours:set(Colours.red, alpha)
	lg.circle("fill", self.bulletX, self.bulletY, 5)
end

function Gun:drawCrosshair()
	local x
	local y

	x, y = love.mouse.getPosition()
	Colours:set(Colours.white, alpha)
	if self.aiming and self.aimTime <= self.aimLimit then
		Colours:set(Colours.gold, alpha)
		lg.circle("line", x, y, self:currentAimRadius())
	end
	lg.line(x + self:currentAimRadius(),  y, x + self:currentAimRadius() + 10, y)
	lg.line(x - self:currentAimRadius(),  y, x - self:currentAimRadius() - 10, y)
	lg.line(x, y + self:currentAimRadius(),  x,  y + self:currentAimRadius() + 10)
	lg.line(x, y - self:currentAimRadius(),  x,  y - self:currentAimRadius() - 10)
end

function Gun:draw()
	self:drawCrosshair()
	if self.bulletHoleVisible then self:drawBulletHole() end
end

return Gun
