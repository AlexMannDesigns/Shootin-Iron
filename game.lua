local cron = require 'cron'
local Game = {}

function Game:load()
	self.target = {}
	self.target.radius = 50
	math.randomseed(os.time()) --random number seeding is required
	self.target.x, self.target.y = self:positionTarget()

	self.score = 0
	self.seconds = 0
	self.ammo = 6
	self.timer = cron.every(1, function() self.seconds = self.seconds + 1 end) 
	self.initialtime = love.timer.getTime()
	self.font = love.graphics.newFont(40)
end

function Game:shoot( x, y, button)
	if button == 1 and self.ammo > 0 then
		if self:distanceBetween(x, y, self.target.x, self.target.y) <= self.target.radius then
			self.score = self.score + 1
			self.target.x, self.target.y = self:positionTarget()
		end
		self.ammo = self.ammo - 1
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

function Game:update(dt)
	self.timer:update(dt)
end

function Game:draw_game_target()
	love.graphics.setColor(love.math.colorFromBytes(0, 153, 0))
	love.graphics.circle("fill", self.target.x, self.target.y, self.target.radius)
end

function Game:draw_game_hud()
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(self.font)
	love.graphics.print("Score:", 0, 0)
	love.graphics.print(self.score, 150, 2)
	love.graphics.print(self.seconds, love.graphics.getWidth() - 150, 2)
end

function Game:draw()
	self:draw_game_target()
	self:draw_game_hud()
end

return Game
