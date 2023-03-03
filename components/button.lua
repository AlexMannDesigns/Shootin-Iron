local lg = love.graphics

function Button(func, textX, textY, buttonX, buttonY, textColour, buttonColour, width, height, text)
	local btnText = {
		y = buttonY,
		x = buttonX
	}
	func = func or function() print("this button has no function") end
	if textY then btnText.y = textY + buttonY end
	if textX then btnText.x = textX + buttonX end
	
--	print(buttonX, buttonY, width, height)
	return {
		textColour = textColour or {r = 0, g = 0, b = 0},
		buttonColour = buttonColour or {r = 1, g = 1, b = 1},
		width = width or 200,
		height = height or 100,
		
		buttonX = buttonX or 0, 
		buttonY = buttonY or 0, 
		
		text = text or "No text added",
		-- create text component function
		--textComponent = 

		draw = function(self)
			lg.setColor(self.buttonColour["r"], self.buttonColour["g"], self.buttonColour["b"])
			lg.rectangle("fill", self.buttonX, self.buttonY, self.width, self.height)
			lg.setColor(self.textColour["r"], self.textColour["g"], self.textColour["b"])
			lg.print(text, btnText.x, btnText.y)
			lg.setColor(1,1,1)
		end
	}
end

return Button 
