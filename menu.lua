local love = require("love")
local Button = require("components/button")
local State = require("state")

local Menu = {}
local lg = love.graphics
local scrnWidth, scrnHeight = lg.getDimensions()

function Menu:load()
	self.funcs = {
		start = function() State:startGame() end,
		quit = function() love.event.quit() end
	}
	self.buttons = {
		Button(self.funcs.start, 20, 30, (scrnWidth / 3), (scrnHeight / 3), nil, nil, nil, nil, "new game"),
		Button(self.funcs.quit, 20, 30, (scrnWidth / 3), (scrnHeight / 3) + 110, nil, nil, nil, nil, "quit")
	}
end

function Menu:draw()
	for _, btn in pairs(self.buttons) do
		btn:draw()
	end
end

function Menu:checkClicked(x, y, mouseButton)
	if mouseButton ~= 1 then return end
	for _, btn in pairs(self.buttons) do
		if x >= btn.buttonX and x <= btn.buttonX + btn.width
			and y >= btn.buttonY and y <= btn.buttonY + btn.height then
			btn:clicked()
		end
	end
end

return Menu
