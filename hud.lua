local Game = require("game")
local Gun = require("gun")
local Colours = require("components/colours")
local Text = require("components/text")

local Hud = {}
local lg = love.graphics

function Hud:load()
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
function Hud:drawAimMeter(scrnWidth, scrnHeight, alpha)
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
	Colours:set(Colours.white, 1)
end

function Hud:drawAmmo(scrnWidth, scrnHeight, alpha)
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
	Colours:set(Colours.white, 1)
end

function Hud:draw()
	local scrnWidth, scrnHeight = lg.getDimensions()
	local alpha = 1
	if self:checkCursorHudOverlap(scrnWidth, scrnHeight) then alpha = 0.2 end

	Text(Game.seconds, scrnWidth - 150, 0, "h3", nil, nil, nil, nil, alpha, nil):draw()
	Text("Score: " .. Game.score, 0, 0, "h3", nil, nil, nil, nil, alpha, nil):draw()
	if Gun.ammo > 0 then Hud:drawAmmo(scrnWidth, scrnHeight, alpha) end
	if Gun.aimTime > 0 then Hud:drawAimMeter(scrnWidth, scrnHeight, alpha) end
end

return Hud
