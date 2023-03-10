local love = require("love")
local Colours = require("components/colours")
local lg = love.graphics
-- component function for handling how text will be displayed throughout the game

function Text(text, x, y, fontSize, fadeIn, fadeOut, wrapWidth, align, opacity, colour)
	fontSize = fontSize or "p"
	fadeIn = fadeIn or false
	fadeOut = fadeOut or false
	wrapWidth = wrapWidth or lg.getWidth()
	align = align or "left"
	opacity = opacity or 1
	colour = colour or Colours.white

	local TEXT_FADE_DUR = 5 --const handles the fade duration
	local fonts = {
		h1 = lg.newFont("assets/Carnevalee Freakshow.ttf", 100),
		h2 = lg.newFont("assets/Carnevalee Freakshow.ttf", 90),
		h3 = lg.newFont("assets/duality.otf", 80),
		h4 = lg.newFont("assets/duality.otf", 70),
		h5 = lg.newFont("assets/duality.otf", 60),
		h6 = lg.newFont("assets/duality.otf", 30),
		p = lg.newFont("assets/duality.otf", 50),
	}

	if fadeIn then
		opacity = 0.1
	end

	return {
		text = text,
		x = x,
		y = y,
		opacity = opacity,
		draw = function(self, tbl_text, index)
			if self.opacity > 0 then
				lg.setFont(fonts[fontSize])
				Colours:set(colour, self.opacity)
				lg.printf(self.text, self.x, self.y, wrapWidth, align)
				Colours:set(Colours.white, 1)
			else
				table.remove(tbl_text, index)
				return false
			end
			return true
		end
	}
end

return Text
