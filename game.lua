local love = require("love")
local cron = require("libraries/cron")
local State = require("state")
local Colours = require("components/colours")

local Game = {}
local targets = {}
local lg = love.graphics
local scrnWidth, scrnHeight = lg.getDimensions()
local alpha = 1
local bullseye = 0.1
local inner = 0.4
local outer = 0.8
local bullseyePoints = 100
local innerPoints = 50
local outerPoints = 20
local targetPoints = 10

--[[
-- The Game class tracks the positioning and drawing of the targets and the
-- timer and score.
]]--
function Game:load()
	math.randomseed(os.time()) -- random number seeding is required to position targets

	self.targetCoolDownTime = 3
	self.targetTimer = 4
	self.minTargets = 1
	self.maxTargets = 3
	self.minRadius = 60
	self.maxRadius = 80
	self.pointsTimerLimit = 2
	self:initialiseGame()
end

function Game:initialiseGame()
	self.score = 0
	self.seconds = 60
	self.timer = cron.every(1, function() self.seconds = self.seconds - 1 end)
	self.targetCurrentTime = 0
	self.targetCoolDown = self.targetCoolDownTime
	self.finished = false
	self.currentPoints = nil
	self.pointsYAnimate = 0
end

-- TARGET HANDLERS --

-- positions target at a random point within the window
function Game:positionTarget(target)
	target.x = math.random(target.radius, scrnWidth - target.radius)
	target.y = math.random(target.radius, scrnHeight - target.radius)
end

function Game:addTarget()
	targets[#targets+1] = {
		radius = math.random(self.minRadius, self.maxRadius),
		x = nil,
		y = nil,
		countdown = #targets * 0.2,
		colour = Colours:getTargetColour()
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

function Game:removeAllTargets()
	for i=1,#targets,1 do
		table.remove(targets)
	end
	self.targetCurrentTime = 0
end

function Game:removeTargets()
	if self.targetCurrentTime >= self.targetTimer then
		self:removeAllTargets()
	end
end

function Game:incrementTargetTimer(dt)
	if #targets > 0 then
		self.targetCurrentTime = self.targetCurrentTime + dt
		self:removeTargets()
	end
end

-- calculates the distance from the mouse click and the centre of the target
function Game:distanceBetween(mouseX, mouseY, targetX, targetY)
	return math.sqrt(((mouseX - targetX) ^ 2) + ((mouseY - targetY) ^ 2))
end

function Game:targetHit(x, y, i)
	return self:distanceBetween(x, y, targets[i].x, targets[i].y) <= targets[i].radius
end

function Game:bullseyeHit(x, y, i)
	return self:distanceBetween(x, y, targets[i].x, targets[i].y) <= targets[i].radius * bullseye
end

function Game:innerHit(x, y, i)
	return self:distanceBetween(x, y, targets[i].x, targets[i].y) <= targets[i].radius * inner
end

function Game:outerHit(x, y, i)
	return self:distanceBetween(x, y, targets[i].x, targets[i].y) <= targets[i].radius * outer
end
-- the score scales depending on which "ring" of the target was hit
function Game:checkHit(x, y)
	for i=#targets, 1, -1 do
		if self:targetHit(x, y, i) then
			if self:bullseyeHit(x, y, i) then
				self.score = self.score + bullseyePoints
				self.currentPoints = bullseyePoints
			elseif self:innerHit(x, y, i) then
				self.score = self.score + innerPoints
				self.currentPoints = innerPoints
			elseif self:outerHit(x, y, i) then
				self.score = self.score + outerPoints
				self.currentPoints = outerPoints
			else
				self.score = self.score + targetPoints
				self.currentPoints = targetPoints
			end
			self.pointsX, self.pointsY = targets[i].x, targets[i].y
			self.pointsTimer = self.pointsTimerLimit
			self.pointsYAnimate = 0
			table.remove(targets, i)
			return
		end
	end
end

function Game:checkGameEnd()
	if self.seconds <= 0 then
		self.finished = true
	end
end

-- at the start of the game there are fewer, bigger targets
-- as the seconds tick down they are smaller and more numerous
-- The time they are on screen and the pause between also reduce
function Game:increaseDifficulty()
	if self.seconds < 15 then
		self.targetCoolDownTime = 1
		self.targetTimer = 2
		self.minTargets = 6
		self.maxTargets = 10
		self.minRadius = 30
		self.maxRadius = 50
	elseif self.seconds < 30 then
		self.targetCoolDownTime = 2
		self.targetTimer = 3
		self.minTargets = 5
		self.maxTargets = 8
		self.minRadius = 40
		self.maxRadius = 60
	elseif self.seconds < 45 then
		self.targetCoolDownTime = 2
		self.targetTimer = 3
		self.minTargets = 3
		self.maxTargets = 7
		self.minRadius = 50
		self.maxRadius = 70
	end
end

function Game:decrementPointsTimer(dt)
	if self.currentPoints and self.pointsTimer > 0 then
		self.pointsTimer = self.pointsTimer - dt
		if self.pointsYAnimate < 50 then
			self.pointsYAnimate = self.pointsYAnimate + 1
		end
	end
end

function Game:decrementTargetCountdown(dt)
	for _,target in pairs(targets) do
		if target.countdown > 0 then
			target.countdown = target.countdown - dt
		end
	end
end

function Game:update(dt)
	self.timer:update(dt)
	self:checkGameEnd()
	self:createTargets(dt)
	self:incrementTargetTimer(dt)
	self:decrementTargetCountdown(dt)
	self:increaseDifficulty()
	self:decrementPointsTimer(dt)
end

-- DRAW FUNCTIONS --

-- This draws the targets, the goto continue if statement is a lua workaround
-- Basically, until the countdown on each target ticks down to 0, we don't want
-- it to be drawn so we can get a sequential pop-in effect
function Game:drawGameTargets()
	for _,target in pairs(targets) do
		if target.countdown > 0 then goto continue end
		Colours:set(target.colour, alpha)
		lg.circle("fill", target.x, target.y, target.radius)
		Colours:set(Colours.white, alpha)
		lg.circle("fill", target.x, target.y, target.radius * outer)
		Colours:set(target.colour, alpha)
		lg.circle("fill", target.x, target.y, target.radius * inner)
		Colours:set(Colours.white, alpha)
		lg.circle("fill", target.x, target.y, target.radius * bullseye)
		::continue::
	end
end

function Game:draw()
	self:drawGameTargets()
	if self.currentPoints and self.pointsTimer > 0 then
		Text(self.currentPoints, self.pointsX, self.pointsY - self.pointsYAnimate):draw()
	end
end

return Game
