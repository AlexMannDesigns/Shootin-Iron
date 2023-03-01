local Game = require("game")
local Gun = require("gun")
local Hud = require("hud")

--Keys object can be global for now...
Keys = {}

Keys.reloadKey = "space"
Keys.shootButton = 1
Keys.aimButton = 2

--[[ TODO ]]--
-- look up how to set colours in a more readable fashion
-- make hud transparent when crosshair is over it
-- Menu screen when the game starts
-- Add level system
	-- Timer should count down, rather than up
	-- Introduce more difficulty (more targets, less time)
	-- Overall score should be tracked between levels
-- Power ups (faster reload, higher capacity, rapid fire)
-- Add sounds (gunshot, reload, ricochets, hammer click)
-- Make it pretty
	-- Add a nice font for the hud
	-- Make the targets look like targets
	-- Add a background
	-- Add a crosshair

-- MAIN FUNCTIONS --

-- called when the game starts. Handles all the setup stuff
function love.load()
	gameState = 0
	if gameState == 0 then
		Game:load()
		Gun:load()	
		Hud:load()
	end
end

-- called 60 times per second. Handles the main game loop
function love.update(dt)
	if gameState == 0 then
		Game:update(dt)
		Gun:update(dt)
		Hud:update(dt)
	end
end

-- called 60 times per second. Handles graphical elements of the game
function love.draw()
	if gameState == 0 then
		Game:draw()
		Gun:draw()
		Hud:draw()
	end
end

-- KEY HANDLERS --

function love.mousepressed(x, y, button, istouch, presses)
	if gameState == 0 then
		Gun:shoot(x, y, button)
	end
end

function love.keypressed(key)
	if key == "escape" then -- placeholder to close the game while testing
		love.event.quit()
	end
end

