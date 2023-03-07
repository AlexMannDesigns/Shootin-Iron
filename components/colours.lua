-- colour setting is dealt with in this class to make code in the rest of the program more readable
-- colour palette: https://coolors.co/palette/03071e-370617-6a040f-9d0208-d00000-dc2f02-e85d04-f48c06-faa307-ffba08
local love = require("love")

local Colours = {}
local lg = love.graphics
local lm = love.math

Colours.white = 1
Colours.lightYellow = 2
Colours.darkYellow = 3
Colours.gold = 4
Colours.orange = 5
Colours.red = 6
Colours.lightRed = 7
Colours.darkRed = 8
Colours.purple = 9
Colours.indigo = 10
Colours.black = 11

function Colours:set(colour, alpha)
	local cfbAlpha = alpha * 255
	if colour == self.lightYellow then lg.setColor(lm.colorFromBytes(255, 186, 8, cfbAlpha)) return end
	if colour == self.darkYellow then lg.setColor(lm.colorFromBytes(250, 163, 7, cfbAlpha)) return end
	if colour == self.gold then lg.setColor(lm.colorFromBytes(244, 140, 6, cfbAlpha)) return end
	if colour == self.orange then lg.setColor(lm.colorFromBytes(232, 93, 4, cfbAlpha)) return end
	if colour == self.white then lg.setColor(lm.colorFromBytes(255, 255, 255, cfbAlpha)) return end
	if colour == self.red then lg.setColor(lm.colorFromBytes(157, 2, 8, cfbAlpha)) return end
	if colour == self.lightRed then lg.setColor(lm.colorFromBytes(208, 0, 0, cfbAlpha)) return end
	if colour == self.darkRed then lg.setColor(lm.colorFromBytes(106, 4, 15, cfbAlpha)) return end
	if colour == self.purple then lg.setColor(lm.colorFromBytes(55, 6, 23, cfbAlpha)) return end
	if colour == self.indigo then lg.setColor(lm.colorFromBytes(3, 7, 30, cfbAlpha)) return end
	if colour == self.black then lg.setColor(lm.colorFromBytes(0, 0, 0, cfbAlpha)) return end
end

function Colours:getTargetColour()
	local targetColours = {
		Colours.orange,
		Colours.lightRed,
		Colours.darkRed,
		Colours.purple,
		Colours.indigo
	}
	return targetColours[math.floor(math.random(1, #targetColours))]
end

return Colours
