local Game = require("game")
local Gun = require("gun")
local Colours = require("colours")

local Hud = {}
local lg = love.graphics
local alpha = 1

function Hud:load()
	self.font = lg.newFont(40)
end

function Hud:update(dt)
end

function Hud:checkCursorHudOverlap(scrnWidth, scrnHeight)
	local x
	local y
	
	x, y = love.mouse.getPosition()
	return (x > scrnWidth * 0.8 and y > scrnHeight * 0.8) or y < scrnHeight * 0.2
end

--gun.aimTime should draw a rectangle on the screen to act as a stamina meter
function Hud:drawAimMeter(scrnWidth, scrnHeight)
	Colours:set(Colours.white, alpha)
	if Gun.aimTime > Gun.aimLimit * 0.8 then
		Colours:set(Colours.red, alpha)
	end
	x = scrnWidth - 30
	y = scrnHeight - 30
	lg.push()
	lg.translate(x, y)
	lg.rotate(3.14159)
	lg.rectangle("fill", 0, 0, 20, Gun.aimTime * 100)
	lg.pop()
end

function Hud:drawAmmo(scrnWidth, scrnHeight)
	local bulletWidth = 30
	local bulletHeight = 10
	local bulletPadding = 3

	x = scrnWidth - 90 
	y = scrnHeight - 40

	Colours:set(Colours.gold, alpha)
	for i=1,Gun.ammo, 1 do
		lg.rectangle("fill", x, y, bulletWidth, bulletHeight)
		y = y - bulletHeight - bulletPadding
	end
end

function Hud:draw()
	local scrnWidth
	local scrnHeight

	scrnWidth = lg.getWidth()
	scrnHeight = lg.getHeight()
	if self:checkCursorHudOverlap(scrnWidth, scrnHeight) then
		alpha = 0.2
	else
		alpha = 1
	end
	Colours:set(Colours.white, alpha)
	lg.setFont(self.font)
	lg.print("Score:", 0, 0)
	lg.print(Game.score, 150, 2)
	lg.print(Game.seconds, scrnWidth - 150, 2)
	if Gun.ammo > 0 then Hud:drawAmmo(scrnWidth, scrnHeight) end
	if Gun.aimTime > 0 then Hud:drawAimMeter(scrnWidth, scrnHeight) end
end

return Hud
