local cron = require 'cron'
local Game = {}

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

function Game:shoot( x, y, button)
	if button == 1 and self.ammo > 0 and self.reloading == false then
		if self:distanceBetween(x, y, self.target.x, self.target.y) <= self.target.radius then
			self.score = self.score + 1
			self.target.x, self.target.y = self:positionTarget()
		end
		self.ammo = self.ammo - 1
	end
end

function Game:reload(key)
	if key == "space" and self.reloading == false then
		self.reloadTime = self.reloadDuration * (self.ammoCap - self.ammo)
		self.ammo = self.ammoCap
		self.reloading = true
	end
end

function Game:positionTarget()
	x = math.random(self.target.radius, love.graphics.getWidth() - self.target.radius)
	y = math.random(self.target.radius, love.graphics.getHeight() - self.target.radius)
	return x, y
end

function Game:distanceBetween(mouseX, mouseY, targetX, targetY)
	return math.sqrt( math.pow((mouseX - targetX), 2) + math.pow((mouseY - targetY), 2) )
end

function Game:decreaseReloadTime(dt)
	if self.reloading then
		self.reloadTime = self.reloadTime - dt
		if self.reloadTime <= 0 then
			self.reloading = false
		end
	end
end

function Game:update(dt)
	self.timer:update(dt)
	self:decreaseReloadTime(dt)
end

function Game:drawGameTarget()
	love.graphics.setColor(love.math.colorFromBytes(0, 153, 0))
	love.graphics.circle("fill", self.target.x, self.target.y, self.target.radius)
end

function Game:drawGameHud()
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(self.font)
	love.graphics.print("Score:", 0, 0)
	love.graphics.print(self.score, 150, 2)
	love.graphics.print(self.seconds, love.graphics.getWidth() - 150, 2)
end

function Game:draw()
	self:drawGameTarget()
	self:drawGameHud()
end

return Game
