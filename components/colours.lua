-- colour setting is dealt with in this class to make code in the rest of the program more readable
local love = require("love")

local Colours = {}
local lg = love.graphics
local lm = love.math

Colours.gold = 1
Colours.white = 2
Colours.red = 3
Colours.green = 4
Colours.black = 5

function Colours:set(colour, alpha)
	local cfbAlpha = alpha * 255
	if colour == self.gold then lg.setColor(lm.colorFromBytes(255, 192, 0, cfbAlpha)) return end
	if colour == self.white then lg.setColor(lm.colorFromBytes(255, 255, 255, cfbAlpha)) return end
	if colour == self.black then lg.setColor(lm.colorFromBytes(0, 0, 0, cfbAlpha)) return end
	if colour == self.red then lg.setColor(lm.colorFromBytes(255, 0, 0, cfbAlpha)) return end
	if colour == self.green then lg.setColor(lm.colorFromBytes(0, 153, 0, cfbAlpha)) return end
end

return Colours
