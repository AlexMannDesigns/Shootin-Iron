-- gunshot sounds royalty free from https://www.fesliyanstudios.com/royalty-free-sound-effects-download/gun-shooting-300
-- title font https://www.dafont.com/carnivalee-freakshow.font
-- text font https://www.dafont.com/duality.font

local love = require("love")
local Game = require("game")
local Gun = require("gun")
local Hud = require("hud")
local Menu = require("menu")
local Score = require("score")
local Instructions = require("instructions")
local State = require("state")
local Colours = require("components/colours")

--[[ GLOBAL VARS ]]--

--Keys object can be global for now...
Keys = {}

Keys.reloadKey = "space"
Keys.shootButton = 1
Keys.aimButton = 2

--[[ TODO ]]--
-- figure out how to embed the game online somewhere - download link to exec might be easier
-- Power ups (faster reload, higher capacity, rapid fire)
-- Add an easter egg
-- Add sounds (gunshot, reload, ricochets, hammer click)

local lg = love.graphics
local background = nil
local angle = 0 --for calculating spin of cursor

-- MAIN FUNCTIONS --

-- called when the game starts. Handles all the setup stuff
function love.load()
	background = lg.newImage("assets/background.png")
	background:setFilter("nearest", "nearest")
	love.mouse.setVisible(false)
	State:load()
	Game:load()
	Gun:load()
	Hud:load()
	Menu:load()
	Score:load()
end

-- called 60 times per second. Handles the main game loop
function love.update(dt)
	angle = angle + .5*math.pi * dt
	if State.inGame then
		if Game.finished then GameOver() end
		Game:update(dt)
		Gun:update(dt)
		Hud:update(dt)
	elseif State.score then
		Score:update(dt)
	end
end

-- called 60 times per second. Handles graphical elements of the game
function love.draw()
	lg.setBackgroundColor(love.math.colorFromBytes(255,186,8)) --placeholder
	Colours:set(Colours.white, 1)
	lg.draw(background, 0, 0, 0, 2)
	if State.inGame then
		Game:draw()
		Gun:draw(angle)
		Hud:draw()
	elseif State.mainMenu then
		Menu:draw(angle)
	elseif State.score then
		Score:draw(angle)
	end
	if love.keyboard.isDown("i") then
		Instructions():draw()
	end
end

-- resets all stats to zero when the game reaches its end state
function GameOver()
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
	elseif key == "q" then -- placeholder to test score screen
		GameOver()
	end
end