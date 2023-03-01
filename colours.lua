-- colour setting is dealt with in this class to make code in the rest of the program more readable
local Colours = {}

local lg = love.graphics
local lm = love.math

Colours.gold = 1
Colours.white = 2
Colours.red = 3
Colours.green = 4

function Colours:set(colour)
	if colour == self.gold then lg.setColor(lm.colorFromBytes(255, 192, 0)) return end
	if colour == self.white then lg.setColor(1, 1, 1) return end
	if colour == self.red then lg.setColor(1, 0, 0) return end
	if colour == self.green then lg.setColor(lm.colorFromBytes(0, 153, 0)) return end
end

return Colours
