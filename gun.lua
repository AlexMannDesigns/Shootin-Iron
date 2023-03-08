local love = require("love")
local anim8 = require("libraries/anim8")
local Game = require("game")
local Colours = require("components/colours")

local Gun = {}
local lg = love.graphics
local alpha = 1
local angle = 0
local gunSprites, gunAnimation
local scrnWidth, scrnHeight = lg.getDimensions()

function Gun:load()
	gunSprites = lg.newImage("assets/gunny.png")
	gunSprites:setFilter("nearest", "nearest")
	local grid = anim8.newGrid(32,32, gunSprites:getWidth(), gunSprites:getHeight())
	gunAnimation = anim8.newAnimation(grid("1-6", 1), 0.1, "pauseAtStart")
	self.ammoCap = 6
	self.reloadDuration = 0.5
	self.aimLimit = 2
	self.aimRadius = 100
	self.minRadius = 10
	self.shotCoolDownDuration = 0.2
	self.bulletHoleTimeLimit = 2
	self:initialiseGun()
end

function Gun:initialiseGun()
	self.ammo = self.ammoCap
	self.reloadKeyDown = 0
	self.aimTime = 0
	self.inShotCoolDown = false
	self.shotCoolDownTime = 0
	self.bulletX = 0
	self.bulletY = 0
	self.bulletHoleVisible = false
	self.bang = false
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
	if self.aiming == true and self.reloading == false and self.aimTime <= self.aimLimit then
		self.aimTime = self.aimTime + dt
		if self.aimTime >= self.aimLimit then
			self.aiming = false
		end
	end
end

function Gun:randomiseShot(x, y)
	local randomX
	local randomY

	randomX = x + math.floor(math.random(0 - self:currentAimRadius() * 0.9, self:currentAimRadius() * 0.9))
	randomY = y + math.floor(math.random(0 - self:currentAimRadius() * 0.9, self:currentAimRadius() * 0.9))
	return randomX, randomY
end

function Gun:shoot(x, y, button)
	if self:playerCanShoot(button) then
		self.bulletX, self.bulletY = self:randomiseShot(x, y)
		self.bulletHoleVisible = true
		self.bulletHoleTime = self.bulletHoleTimeLimit
		Game:checkHit(self.bulletX, self.bulletY)
		self.ammo = self.ammo - 1
		self.inShotCoolDown = true
		self.shotCoolDownTime = self.shotCoolDownDuration
		self.bang = true
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
			self.bang = false
		end
	end
end

function Gun:decreaseAimTime(dt)
	if (self.aiming == false or self.reloading == true) and self.aimTime > 0 then
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
	self.aiming = love.mouse.isDown(Keys.aimButton)
	self.reloading = love.keyboard.isDown(Keys.reloadKey)
	self:reload(dt)
	self:decreaseShotCoolDown(dt)
	self:decreaseBulletHoleTime(dt)
	self:decreaseAimTime(dt)
	self:aim(dt)
	gunAnimation:update(dt)
	angle = angle + .5*math.pi * dt
end

function Gun:currentAimRadius()
	local radius
	if self.aiming and self.aimTime < self.aimLimit then
		radius = math.floor(self.aimRadius * (1 - (self.aimTime / self.aimLimit)))
		if radius >= self.minRadius then return radius end
		return self.minRadius
	end
	return self.aimRadius
end

function Gun:drawBulletHole()
	Colours:set(Colours.red, alpha)
	lg.circle("fill", self.bulletX, self.bulletY, 5)
	Colours:set(Colours.white, alpha)
end

function Gun:drawCrosshair()
	local x, y = love.mouse.getPosition()
	Colours:set(Colours.indigo, alpha)
	lg.push()
	if self.aiming and self.aimTime <= self.aimLimit then
		Colours:set(Colours.lightRed, alpha)
		lg.circle("line", x, y, self:currentAimRadius())
		lg.translate(x, y)
		lg.rotate(angle)
		lg.translate(-x, -y)
	end
	lg.line(x + self:currentAimRadius(),  y, x + self:currentAimRadius() + 10, y)
	lg.line(x - self:currentAimRadius(),  y, x - self:currentAimRadius() - 10, y)
	lg.line(x, y + self:currentAimRadius(),  x,  y + self:currentAimRadius() + 10)
	lg.line(x, y - self:currentAimRadius(),  x,  y - self:currentAimRadius() - 10)
	lg.pop()
	Colours:set(Colours.white, alpha)
end

function Gun:draw()
	if self.reloading == false and self.inShotCoolDown == false then
		self:drawCrosshair()
	end
	if self.bulletHoleVisible then self:drawBulletHole() end
	if self.bang == false then gunAnimation:gotoFrame(1) end
	gunAnimation:draw(
		gunSprites,
		(scrnWidth / 2) - ((gunSprites:getWidth() / 6) * 2),
		scrnHeight - (gunSprites:getHeight() * 4),
		nil,
		4
	)
end

return Gun
