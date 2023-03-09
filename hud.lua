local love = require("love")
local anim8 = require("libraries/anim8")
local Game = require("game")
local Gun = require("gun")
local Colours = require("components/colours")

local Hud = {}
local lg = love.graphics
local hourGlassSprites, hourGlassAnimation
local scrnWidth, scrnHeight = lg.getDimensions()
local alpha = 1

function Hud:load()
	hourGlassSprites = lg.newImage("assets/hourglass.png")
	hourGlassSprites:setFilter("nearest", "nearest")
	local grid = anim8.newGrid(32,32, hourGlassSprites:getWidth(), hourGlassSprites:getHeight())
	hourGlassAnimation = anim8.newAnimation(grid("1-6", 1), 0.2)
end

function Hud:update(dt)
	if Game.seconds > 50 then
		hourGlassAnimation:gotoFrame(1)
	elseif Game.seconds > 40 then
		hourGlassAnimation:gotoFrame(2)
	elseif Game.seconds > 30 then 
		hourGlassAnimation:gotoFrame(3)
	elseif Game.seconds > 20 then 
		hourGlassAnimation:gotoFrame(4)
	elseif Game.seconds > 10 then
		hourGlassAnimation:gotoFrame(5)
	else
		hourGlassAnimation:gotoFrame(6)
	end
	hourGlassAnimation:update(dt)
end

function Hud:checkCursorHudOverlap()
	local x, y = love.mouse.getPosition()
	return (x > scrnWidth * 0.8 and y > scrnHeight * 0.8) or (x < scrnWidth * 0.2 and y > scrnHeight * 0.8)
end

--gun.aimTime draws a rectangle on the screen to act as a stamina meter
function Hud:drawAimMeter()
	Colours:set(Colours.white, alpha)
	if Gun.aimTime > Gun.aimLimit * 0.8 then
		Colours:set(Colours.lightRed, alpha)
	end
	local x = scrnWidth - 30
	local y = scrnHeight - 30
	lg.push()
	lg.translate(x, y)
	lg.rotate(3.14159)
	lg.rectangle("fill", 0, 0, 20, Gun.aimTime * 100)
	lg.pop()
	Colours:set(Colours.white, 1)
end

function Hud:drawAmmo()
	local bulletWidth = 25
	local bulletHeight = 10
	local bulletPadding = 3
	local x = scrnWidth - 90
	local y = scrnHeight - 40

	Colours:set(Colours.gold, alpha)
	for i=1,Gun.ammo, 1 do
		lg.circle("fill", x + bulletWidth, y + bulletHeight / 2, bulletHeight / 2)
		lg.rectangle("fill", x, y, bulletWidth, bulletHeight)
		y = y - bulletHeight - bulletPadding
	end
	Colours:set(Colours.white, 1)
end

function Hud:draw()
	if self:checkCursorHudOverlap() then
		alpha = 0.2
	else
		alpha = 1
	end
	lg.setColor(1,1,1,alpha)
	hourGlassAnimation:draw(
		hourGlassSprites,
		30,
		scrnHeight - hourGlassSprites:getHeight() - 60,
		nil,
		2
	)
	if Gun.ammo > 0 then Hud:drawAmmo() end
	if Gun.aimTime > 0 then Hud:drawAimMeter() end
end

return Hud
