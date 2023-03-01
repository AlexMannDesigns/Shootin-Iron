local cron = require 'cron'
local Game = {}

local targets = {}

local lg = love.graphics

--[[
-- The Game class tracks the positioning and drawing of the targets and the
-- player actions, timer and score.
]]--
function Game:load()
	math.randomseed(os.time()) -- random number seeding is required to position targets

	self.targetCoolDownTime = 2
	self.targetCoolDown = self.targetCoolDownTime
	self.targetTimer = 3 
	self.targetCurrentTime = 0
	self.minTargets = 1 
	self.maxTargets = 6 
	self.minRadius = 30
	self.maxRadius = 70
	self.score = 0
	self.seconds = 0
	self.timer = cron.every(1, function() self.seconds = self.seconds + 1 end) 
	self.initialTime = love.timer.getTime()
end

-- TARGET HANDLERS --

-- positions target at a random point within the window
function Game:positionTarget(target)
	target.x = math.random(target.radius, lg.getWidth() - target.radius)
	target.y = math.random(target.radius, lg.getHeight() - target.radius)
end

function Game:addTarget()
	targets[#targets+1] = {
		radius = math.random(self.minRadius, self.maxRadius),
		x = 0,
		y = 0
	}
	self:positionTarget(targets[#targets])
end

--creates targets when there are none present. Ticks down the cool down timer
--before next targets are created
function Game:createTargets(dt)
	local numberOfTargets = math.random(self.minTargets, self.maxTargets) 
	if #targets == 0 then
		self.targetCurrentTime = 0
		if self.targetCoolDown > 0 then
			self.targetCoolDown = self.targetCoolDown - dt
		else
			for i=1,numberOfTargets,1 do
				self:addTarget()
			end
			self.targetCoolDown = self.targetCoolDownTime
		end
	end
end

function Game:removeTargets()
	if self.targetCurrentTime >= self.targetTimer then
		for i=1,#targets,1 do
			table.remove(targets)
		end
		self.targetCurrentTime = 0
	end
end

function Game:incrementTargetTimer(dt)
	if #targets > 0 then
		self.targetCurrentTime = self.targetCurrentTime + dt
		if self.targetCurrentTime >= self.targetTimer then
			self:removeTargets()
		end
	end
end

-- calculates the distance from the mouse click and the centre of the target
function Game:distanceBetween(mouseX, mouseY, targetX, targetY)
	return math.sqrt( math.pow((mouseX - targetX), 2) + math.pow((mouseY - targetY), 2) )
end
	
function Game:checkHit(x, y)
	for i=#targets, 1, -1 do
		if self:distanceBetween(x, y, targets[i].x, targets[i].y) <= targets[i].radius then
			self.score = self.score + 1
			table.remove(targets, i)
			return 
		end
	end
end

function Game:update(dt)
	self.timer:update(dt)
	self:createTargets(dt)
	self:incrementTargetTimer(dt)
end

-- DRAW FUNCTIONS --

-- nothing special here yet, everything about how the game looks is basically a placeholder 

function Game:drawGameTargets()
	for i=1,#targets,1 do
		lg.setColor(love.math.colorFromBytes(0, 153, 0))
		lg.circle("fill", targets[i].x, targets[i].y, targets[i].radius)
		lg.setColor(1, 1, 1)
		lg.circle("fill", targets[i].x, targets[i].y, targets[i].radius * 0.8)
		lg.setColor(love.math.colorFromBytes(0, 153, 0))
		lg.circle("fill", targets[i].x, targets[i].y, targets[i].radius * 0.4)
	end
end

function Game:draw()
	self:drawGameTargets()
end

return Game
