local love = require("love")
local Button = require("components/button")
local Colours = require("components/colours")
local MenuCursor = require("components/menucursor")
local State = require("state")

local Menu = {}
local lg = love.graphics
local scrnWidth, scrnHeight = lg.getDimensions()
local myFont = lg.newFont("assets/Carnevalee Freakshow.ttf", 100)
local angle = 0

function Menu:load()
	self.funcs = {
		start = function() State:startGame() end,
		quit = function() love.event.quit() end
	}
	self.buttons = {
		Button(self.funcs.start, 40, 15, (scrnWidth / 4), (scrnHeight / 4) * 3, Colours.indigo, Colours.darkYellow, nil, nil, "Start"),
		Button(self.funcs.quit, 50, 15, (scrnWidth / 4) + 220, (scrnHeight / 4) * 3, Colours.indigo, Colours.darkYellow, nil, nil, "Quit")
	}
end

function Menu:draw(angle)
	Text("Wild Wild West", 0, (scrnHeight / 4) - myFont:getHeight(), "h1", nil, nil, nil, "center", 1, Colours.indigo):draw()
	Colours:set(Colours.white, 1)
	for _, btn in pairs(self.buttons) do
		btn:draw()
	end
	MenuCursor(angle):draw()
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
