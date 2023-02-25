local Game = require("game")

--[[ TODO ]]--
-- Make it pretty
-- Add multiple targets
-- Targets disappear after a time
-- Menu screen when the game starts
-- Crosshair
-- Aim-wobble (left-click to hold breath and steady)
-- Add level system
	-- Timer should count down, rather than up
	-- Introduce more difficulty (more targets, less time)
	-- Overall score should be tracked between levels
-- Power ups (faster reload, higher capacity, rapid fire)
-- Add sounds (gunshot, reload, ricochets)

-- MAIN FUNCTIONS --

-- called when the game starts. Handles all the setup stuff
function love.load()
	gameState = 0
	if gameState == 0 then
		Game:load()
	end
end

-- called 60 times per second. Handles the main game loop
function love.update(dt)
	if gameState == 0 then
		Game:update(dt)
	end
end

-- called 60 times per second. Handles graphical elements of the game
function love.draw()
	if gameState == 0 then
		Game:draw()
	end
end

-- KEY HANDLERS --

function love.mousepressed( x, y, button, istouch, presses )
	if gameState == 0 then
		Game:shoot(x, y, button)
	end
end

function love.keypressed(key)
	if gameState == 0 then
		Game:reload(key)
	end
	
	if key == "escape" then -- placeholder to close the game while testing
		love.event.quit()
	end
end
