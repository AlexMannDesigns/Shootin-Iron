local love = require("love")
local Text = require("components/text")
local Colours = require("components/colours")

local lg = love.graphics
local alpha = 1
local scrnWidth, scrnHeight = lg.getDimensions()

function Instructions()
	local CONTROLS = "Shoot: mouse 1\nAim: mouse 2 (press and hold)\nReload: 'space' (press and hold)"
	local INSTRUCTIONS_HEADING = "Instructions:"
	return {
		draw = function(self)
			local instFont = lg.newFont("assets/duality.otf", 50)
			Colours:set(Colours.black, 0.4)
			lg.rectangle("fill", 0, 0, scrnWidth, scrnHeight)
			Colours:set(Colours.white, alpha)
			Text(
				INSTRUCTIONS_HEADING,
				0,
				(scrnHeight / 3) - instFont:getHeight(),
				"p",
				nil,
				nil,
				nil,
				"center",
				alpha,
				Colours.white
			):draw()
			Text(
				CONTROLS,
				0,
				(scrnHeight / 2) - instFont:getHeight(),
				"p",
				nil,
				nil,
				nil,
				"center",
				alpha,
				Colours.white
			):draw()
		end
	}
end

return Instructions