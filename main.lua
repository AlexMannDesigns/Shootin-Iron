local love = require("love")
local Game = require("game")
local Gun = require("gun")
local Hud = require("hud")
local Menu = require("menu")
local Score = require("score")
local State = require("state")
local Colours = require("components/colours")

--[[ GLOBAL VARS ]]--

--Keys object can be global for now...
Keys = {}

Keys.reloadKey = "space"
Keys.shootButton = 1
Keys.aimButton = 2

--[[ TODO ]]--
-- Menu screen when the game starts - Done but needs improving
-- figure out how to embed the game online somewhere - download link to exec might be easier
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
	Score:load()
end

-- called 60 times per second. Handles the main game loop
function love.update(dt)
	if State.inGame then
		if Game.finished then ResetGame() end
		Game:update(dt)
		Gun:update(dt)
		Hud:update(dt)
	elseif State.score then
		Score:update(dt)
	end
end

-- called 60 times per second. Handles graphical elements of the game
function love.draw()
	love.graphics.setBackgroundColor(love.math.colorFromBytes(255,186,8)) --placeholder
	if State.inGame then
		Game:draw()
		Gun:draw()
		Hud:draw()
	elseif State.mainMenu then
		Menu:draw()
	elseif State.score then
		Score:draw()
	end
end

-- resets all stats to zero when the game reaches its end state
function ResetGame()
	Game.finalScore = Game.score
	Game:initialiseGame()
	Game:removeAllTargets()
	Gun:initialiseGun()
	Game.finished = false
	State:endGame()
end

-- KEY HANDLERS --

function love.mousepressed(x, y, button)
	if State.inGame then
		Gun:shoot(x, y, button)
	elseif State.mainMenu then
		Menu:checkClicked(x, y, button)
	elseif State.score then
		Score:checkClicked(x, y, button)
	end
end

function love.keypressed(key)
	if key == "escape" then -- placeholder to close the game while testing
		love.event.quit()
	elseif key == "q" then
		resetGame()
	end
end