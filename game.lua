local cron = require 'cron'
local Game = {}
local reloadKey = "space"
local shootButton = 1

--[[
-- The Game class tracks the positioning and drawing of the targets and the
-- player actions, timer and score.
]]--
function Game:load()
	math.randomseed(os.time()) --random number seeding is required
	
	self.target = {}
	self.target.radius = 50
	self.target.x, self.target.y = self:positionTarget()

	self.score = 0
	self.seconds = 0
	self.ammoCap = 6
	self.ammo = self.ammoCap
	self.reloadTime = 0
	self.reloadDuration = 0.5
	self.reloading = false
	self.timer = cron.every(1, function() self.seconds = self.seconds + 1 end) 
	self.initialTime = love.timer.getTime()
	self.font = love.graphics.newFont(40)
end

-- TARGET HANDLERS --

--positions target at a random point within the window
function Game:positionTarget()
	x = math.random(self.target.radius, love.graphics.getWidth() - self.target.radius)
	y = math.random(self.target.radius, love.graphics.getHeight() - self.target.radius)
	return x, y
end

--calculates the distance from the mouse click and the centre of the target
function Game:distanceBetween(mouseX, mouseY, targetX, targetY)
	return math.sqrt( math.pow((mouseX - targetX), 2) + math.pow((mouseY - targetY), 2) )
end

-- PLAYER ACTION HANDLERS --

--[[ 
-- Shooting is handled by mouse clicks.
-- The player cannot shoot while reloading or when out of ammo.
-- If the player hits the target, the score is incremented
-- Every time the player shoots the ammo counter is decremented
]]-- 
function Game:shoot( x, y, button)
	if button == shootButton and self.ammo > 0 and self.reloading == false then
		if self:distanceBetween(x, y, self.target.x, self.target.y) <= self.target.radius then
			self.score = self.score + 1
			self.target.x, self.target.y = self:positionTarget()
		end
		self.ammo = self.ammo - 1
	end
end

--[[
-- Reloading is dynamic, the gun is a revolver so bullets are placed into the chamber
-- one by one. The total reload time is calculated when the reload button is pressed
-- and the ammo counter then starts gradually incrementing. The reload action can be
-- cancelled by pressing the button again and then the player can continue shooting
-- with a partially empty gun
]]--
function Game:reload(key)
	if key == reloadKey and self.reloading == false then
		self.reloadTime = self.reloadDuration * (self.ammoCap - self.ammo)
		self.reloading = true
	elseif key == reloadKey then
		self.reloading = false
	end
end

function Game:decreaseReloadTime(dt)
	if self.reloading then
		self.reloadTime = self.reloadTime - dt
		self.ammo = math.floor(self.ammoCap - (self.reloadTime / self.reloadDuration))
		if self.reloadTime <= 0 then
			self.reloading = false
		end
	end
end

function Game:update(dt)
	self.timer:update(dt)
	self:decreaseReloadTime(dt)
end

-- DRAW FUNCTIONS --

--nothing special here yet, everything about how the game looks is basically a placeholder 

function Game:drawGameTarget()
	love.graphics.setColor(love.math.colorFromBytes(0, 153, 0))
	love.graphics.circle("fill", self.target.x, self.target.y, self.target.radius)
end

function Game:drawGameHud()
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(self.font)
	love.graphics.print("Score:", 0, 0)
	love.graphics.print(self.score, 150, 2)
	love.graphics.print("Ammo:", 250, 0)
	love.graphics.print(self.ammo, 400, 2)
	love.graphics.print(self.seconds, love.graphics.getWidth() - 150, 2)
end

function Game:draw()
	self:drawGameTarget()
	self:drawGameHud()
end

return Game
