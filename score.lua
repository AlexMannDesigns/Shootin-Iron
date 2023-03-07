-- displays the players score when the game reaches its end state
-- Like the main menu, offers to restart game or quit

local love = require("love")
local Game = require("game")
local Text = require("components/text")
local Colours = require("components/colours")
local Button = require("components/button")

local GAME_OVER = "GAME OVER"
local YOUR_SCORE = "Your score: "

local Score = {}
local lg = love.graphics
local scrnWidth, scrnHeight = lg.getDimensions()


function Score:load()
	self.counter = 0
end

function Score:incrementCounter()
	if self.counter < Game.score then
		if self.counter + 3 <= Game.score then
			self.counter = self.counter + 3 -- when state is changed again, counter should reset to 0
		else
			self.counter = Game.score
		end
	end
end

function Score:update(dt)
	self:incrementCounter()
end

function Score:draw()
	local font = lg.newFont(50)
	Text(GAME_OVER, 0, (scrnHeight / 4) - font:getHeight(), "h2", nil, nil, nil, "center", 1, Colours.white):draw()
	font = lg.newFont(30)
	Text(YOUR_SCORE .. self.counter, 0, (scrnHeight / 2) - font:getHeight(), "h4", nil, nil, nil, "center", 1, Colours.white):draw()
end

return Score