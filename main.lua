local love = require("love")
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
-- Menu screen when the game starts - Done but needs improving
-- figure out how to embed the game online somewhere
-- Timer should count down from 60, then display score at the end and offer to play again or quit
-- Show less targets at the start, more at the end
	-- pause between rounds of targets should progressively get shorter
-- Power ups (faster reload, higher capacity, rapid fire)
-- Add an easter egg
	-- Monkey that runs around the screen and takes you to a 'you lose' screen if you shoot it
-- Add sounds (gunshot, reload, ricochets, hammer click)
-- Make it pretty
	-- Add a nice font for the hud
	-- Make the targets look like targets - Done, add some more colours
	-- Add a background
	-- create custom menu cursor

-- MAIN FUNCTIONS --

-- called when the game starts. Handles all the setup stuff
function love.load()
	State:load()
	Game:load()
	Gun:load()
	Hud:load()
	Menu:load()
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

function love.mousepressed(x, y, button)
	if State.inGame then
		Gun:shoot(x, y, button)
	elseif State.mainMenu then
		Menu:checkClicked(x, y, button)
	end
end

function love.keypressed(key)
	if key == "escape" then -- placeholder to close the game while testing
		love.event.quit()
	end
end

