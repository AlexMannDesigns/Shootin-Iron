-- displays the players score when the game reaches its end state
-- Like the main menu, offers to restart game or quit

local love = require("love")
local Game = require("game")
local State = require("state")
local Text = require("components/text")
local Colours = require("components/colours")
local Button = require("components/button")
local MenuCursor = require("components/menucursor")

local GAME_OVER = "GAME OVER"
local YOUR_SCORE = "Your score: "

local Score = {}
local lg = love.graphics
local scrnWidth, scrnHeight = lg.getDimensions()

function Score:load()
	self.counter = 0
	self.funcs = {
		restart = function()
			self.counter = 0
			State:startGame()
			end,
		quit = function() love.event.quit() end
	}
	self.buttons = {
		Button(self.funcs.restart, 20, 15, (scrnWidth / 4), (scrnHeight / 4) * 3, Colours.indigo, Colours.darkYellow, nil, nil, "Restart"),
		Button(self.funcs.quit, 50, 15, (scrnWidth / 4) + 220, (scrnHeight / 4) * 3, Colours.indigo, Colours.darkYellow, nil, nil, "Quit")
	}
end

function Score:incrementCounter()
	if self.counter < Game.finalScore then
		if self.counter + 3 <= Game.finalScore then
			self.counter = self.counter + 3 -- when state is changed again, counter should reset to 0
		else
			self.counter = Game.finalScore
		end
	end
end

function Score:update(dt)
	self:incrementCounter()
end

function Score:draw(angle)
	local font = lg.newFont("assets/Carnevalee Freakshow.ttf", 100)
	Text(GAME_OVER, 0, (scrnHeight / 4) - font:getHeight(), "h1", nil, nil, nil, "center", 1, Colours.indigo):draw()
	font = lg.newFont("assets/duality.otf", 30)
	Text(YOUR_SCORE .. self.counter, 0, (scrnHeight / 2) - font:getHeight(), "h4", nil, nil, nil, "center", 1, Colours.indigo):draw()
	for _, btn in pairs(self.buttons) do
		btn:draw()
	end
	MenuCursor(angle):draw()
end

function Score:checkClicked(x, y, mouseButton)
	if mouseButton ~= 1 then return end
	for _, btn in pairs(self.buttons) do
		if x >= btn.buttonX and x <= btn.buttonX + btn.width
			and y >= btn.buttonY and y <= btn.buttonY + btn.height then
			btn:clicked()
		end
	end
end

return Score