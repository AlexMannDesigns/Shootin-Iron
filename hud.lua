local Game = require("game")
local Gun = require("gun")
local Colours = require("colours")

local Hud = {}
local lg = love.graphics

function Hud:load()
	self.font = lg.newFont(40)
end

function Hud:update(dt)
end

--gun.aimTime should draw a rectangle on the screen to act as a stamina meter
function Hud:drawAimMeter()
	if Gun.aimTime <= 0 then return end

	Colours:set(Colours.white)
	if Gun.aimTime > Gun.aimLimit * 0.8 then
		Colours:set(Colours.red)
	end
	x = lg.getWidth() - 30
	y = lg.getHeight() - 30
	lg.push()
	lg.translate(x, y)
	lg.rotate(3.14159)
	lg.rectangle("fill", 0, 0, 20, Gun.aimTime * 100)
	lg.pop()
end

function Hud:drawAmmo()
	if Gun.ammo < 1 then return end

	local bulletWidth = 30
	local bulletHeight = 10
	local bulletPadding = 3
	x = lg.getWidth() - 90 
	y = lg.getHeight() - 40

	Colours:set(Colours.gold)
	for i=1,Gun.ammo, 1 do
		lg.rectangle("fill", x, y, bulletWidth, bulletHeight)
		y = y - bulletHeight - bulletPadding
	end
end

function Hud:draw()
	Colours:set(Colours.white)
	lg.setFont(self.font)
	lg.print("Score:", 0, 0)
	lg.print(Game.score, 150, 2)
	lg.print(Game.seconds, lg.getWidth() - 150, 2)
	Hud:drawAmmo()
	Hud:drawAimMeter()
end

return Hud
