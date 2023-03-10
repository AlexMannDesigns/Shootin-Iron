local love = require("love")
local Colours = require("components/colours")

local lg = love.graphics
local alpha = 1


function MenuCursor(angle)
	local x, y = love.mouse.getPosition()
	local radius = 10

	return {
		draw = function(self)
			lg.push()
			Colours:set(Colours.lightRed, alpha)
			lg.circle("line", x, y, radius)
			lg.translate(x, y)
			lg.rotate(angle)
			lg.translate(-x, -y)
			lg.line(x + radius,  y, x + radius + 10, y)
			lg.line(x - radius,  y, x - radius - 10, y)
			lg.line(x, y + radius,  x,  y + radius + 10)
			lg.line(x, y - radius,  x,  y - radius - 10)
			lg.pop()
			Colours:set(Colours.white, alpha)
		end
	}
end

return MenuCursor