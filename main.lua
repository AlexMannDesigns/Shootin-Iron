local cron = require 'cron'

local Game = require("game")

--called when the game starts. Handles all the setup stuff
function love.load()
	game_state = 0
	if game_state == 0 then
		Game:load()
	end
end

--called 60 times per second. Handles the main game loop
function love.update(dt)
	if game_state == 0 then
		Game:update(dt)
	end
end

--called 60 times per second. Handles graphical elements of the game
function love.draw()
	if game_state == 0 then
		Game:draw()
	end
end

function love.mousepressed( x, y, button, istouch, presses )
	if game_state == 0 then
		Game:shoot(x, y, button)
	end
end
