local Game = require("game")
local Gun = require("gun")
local Hud = require("hud")
local Menu = require("menu")
local State = require("state")

--[[ GLOBAL VARS ]]--

--Keys object can be global for now...
Keys = {}

Keys.reloadKey = "space"
Keys.shootButton = 1
Keys.aimButton = 2

--[[ TODO ]]--
-- Menu screen when the game starts
-- figure out how to embed the game online somewhere
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
	-- create custom menu cursor

-- MAIN FUNCTIONS --

-- called when the game starts. Handles all the setup stuff
function love.load()
	State:load()	
	if State.inGame then
		Game:load()
		Gun:load()	
		Hud:load()
	elseif State.mainMenu then
		Menu:load()
	end
end

-- called 60 times per second. Handles the main game loop
function love.update(dt)
	if State.inGame then
		Game:update(dt)
		Gun:update(dt)
		Hud:update(dt)
	end
end

-- called 60 times per second. Handles graphical elements of the game
function love.draw()
	if State.inGame then
		Game:draw()
		Gun:draw()
		Hud:draw()
	elseif State.mainMenu then
		Menu:draw()	
	end
end

-- KEY HANDLERS --

function love.mousepressed(x, y, button, istouch, presses)
	if State.inGame then
		Gun:shoot(x, y, button)
	end
end

function love.keypressed(key)
	if key == "escape" then -- placeholder to close the game while testing
		love.event.quit()
	end
end

