local love = require("love")
local Text = require("components/text")
local Colours = require("components/colours")

local lg = love.graphics
local alpha = 1

function Button(func, textX, textY, buttonX, buttonY, textColour, buttonColour, width, height, text)
	local btnText = {
		y = buttonY,
		x = buttonX
	}
	func = func or function() print("this button has no function") end
	if textY then btnText.y = textY + buttonY end
	if textX then btnText.x = textX + buttonX end

	return {
		textColour = textColour or Colours.black,
		buttonColour = buttonColour or Colours.white,
		width = width or 200,
		height = height or 100,

		buttonX = buttonX or 0,
		buttonY = buttonY or 0,

		text = text or "No text added",
		clicked = function()
			func()
		end,

		draw = function(self)
			local mouseX, mouseY = love.mouse.getPosition()
			Colours:set(buttonColour, alpha)
			if mouseX >= self.buttonX and mouseX <= self.buttonX + self.width and
					mouseY >= self.buttonY and mouseY <= self.buttonY + self.height then
				Colours:set(Colours.lightYellow, alpha)
			end
			lg.rectangle("fill", self.buttonX, self.buttonY, self.width, self.height)
			Text(text, btnText.x, btnText.y, "h5", nil, nil, nil, nil, alpha, textColour):draw()
			lg.setColor(1,1,1)
		end
	}
end

return Button
