local Colours = require("components/colours")
lg = love.graphics

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
		h1 = lg.newFont(60),
		h2 = lg.newFont(50),
		h3 = lg.newFont(40),
		h4 = lg.newFont(30),
		h5 = lg.newFont(20),
		h6 = lg.newFont(10),
		p = lg.newFont(16),
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
			print(self.text, opacity)
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
