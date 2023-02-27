local cron = require 'cron'
local Game = {}

--[[
-- The Game class tracks the positioning and drawing of the targets and the
-- player actions, timer and score.
]]--
function Game:load()
	math.randomseed(os.time()) -- random number seeding is required to position targets
	self.target = {}
	self.target.radius = 50
	self.target.x, self.target.y = self:positionTarget()
	self.score = 0
	self.seconds = 0
	self.timer = cron.every(1, function() self.seconds = self.seconds + 1 end) 
	self.initialTime = love.timer.getTime()
end

-- TARGET HANDLERS --

-- positions target at a random point within the window
function Game:positionTarget()
	x = math.random(self.target.radius, love.graphics.getWidth() - self.target.radius)
	y = math.random(self.target.radius, love.graphics.getHeight() - self.target.radius)
	return x, y
end

-- calculates the distance from the mouse click and the centre of the target
function Game:distanceBetween(mouseX, mouseY, targetX, targetY)
	return math.sqrt( math.pow((mouseX - targetX), 2) + math.pow((mouseY - targetY), 2) )
end
	
function Game:checkHit(x, y)
	if self:distanceBetween(x, y, self.target.x, self.target.y) <= self.target.radius then
		self.score = self.score + 1
		self.target.x, self.target.y = self:positionTarget()
	end
end

-- PLAYER ACTION HANDLERS --

function Game:update(dt)
	self.timer:update(dt)
end

-- DRAW FUNCTIONS --

-- nothing special here yet, everything about how the game looks is basically a placeholder 

function Game:drawGameTarget()
	love.graphics.setColor(love.math.colorFromBytes(0, 153, 0))
	love.graphics.circle("fill", self.target.x, self.target.y, self.target.radius)
end

function Game:draw()
	self:drawGameTarget()
end

return Game
