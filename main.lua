local Game = require("game")

-- MAIN FUNCTIONS --

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

-- KEY HANDLERS --

function love.mousepressed( x, y, button, istouch, presses )
	if game_state == 0 then
		Game:shoot(x, y, button)
	end
end

function love.keypressed(key)
	if game_state == 0 then
		Game:reload(key)
	end
	
	if key == "escape" then --placeholder to close the game while testing
		love.event.quit()
	end
end
