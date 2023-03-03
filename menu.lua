local Button = require("components.button")
local State = require("state")

local Menu = {}

local lg = love.graphics


function Menu:load()
	self.funcs = {
		start = function() State:startGame() end
	}
	self.buttons = {
		Button(self.funcs.start, 20, 30, lg.getWidth() / 3, lg.getHeight() / 3, nil, nil, nil, nil, "new game")
	}
end

function Menu:draw()
	for _, button in pairs(self.buttons) do
		button:draw()
	end
end

return Menu
