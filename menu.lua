local love = require("love")
local anim8 = require("libraries/anim8")
local Button = require("components/button")
local Colours = require("components/colours")
local MenuCursor = require("components/menucursor")
local State = require("state")

local Menu = {}
local lg = love.graphics
local scrnWidth, scrnHeight = lg.getDimensions()
local TITLE = ""
local titleFont = lg.newFont("assets/Carnevalee Freakshow.ttf", 100)
local instructionsFont = lg.newFont("assets/duality.otf", 30)
local menuGunSprites, menuGunAnimation
local animationTime = 1.6
local animating = animationTime
local animationCoolDown = 2
local currentAnimationCoolDown = animationCoolDown

function Menu:load()
	menuGunSprites = lg.newImage("assets/sixiron.png")
	menuGunSprites:setFilter("nearest", "nearest")
	local grid = anim8.newGrid(128,64, menuGunSprites:getWidth(), menuGunSprites:getHeight())
	menuGunAnimation = anim8.newAnimation(grid(1, "1-8"), 0.2)
	self.funcs = {
		start = function() State:startGame() end,
		quit = function() love.event.quit() end
	}
	self.buttons = {
		Button(self.funcs.start, 40, 15, (scrnWidth / 4), (scrnHeight / 4) * 3, Colours.indigo, Colours.darkYellow, nil, nil, "Start"),
		Button(self.funcs.quit, 50, 15, (scrnWidth / 4) + 220, (scrnHeight / 4) * 3, Colours.indigo, Colours.darkYellow, nil, nil, "Quit")
	}
end

function Menu:update(dt)
	animating = animating - dt
	if animating < 0 then
		menuGunAnimation:gotoFrame(8)
		currentAnimationCoolDown = currentAnimationCoolDown - dt
		if currentAnimationCoolDown < 0 then
			currentAnimationCoolDown = animationCoolDown
			animating = animationTime
		end
	end
	menuGunAnimation:update(dt)
end

function Menu:draw(angle)
	Text("Shootin' Iron", 0, (scrnHeight / 4) - titleFont:getHeight(), "h1", nil, nil, nil, "center", 1, Colours.indigo):draw()
	Text("By Alexander Mann", 0, (scrnHeight / 4), "h7", nil, nil, nil, "center", 1, Colours.darkRed):draw()
	Colours:set(Colours.white, 1)
	for _, btn in pairs(self.buttons) do
		btn:draw()
	end
	local gunX = (scrnWidth / 2) - (menuGunSprites:getWidth() * 2)
	local gunY = (scrnHeight / 2) - ((menuGunSprites:getHeight() / 8) * 2)
	menuGunAnimation:draw(
		menuGunSprites,
		gunX,
		gunY + 20,
		nil,
		4
	)
	MenuCursor(angle):draw()
	Text("To display instructions, press 'i' at any time", 0, scrnHeight - 5 - instructionsFont:getHeight(), "h7", nil, nil, nil, "center", 1, Colours.white):draw()
end

function Menu:checkClicked(x, y, mouseButton)
	if mouseButton ~= 1 then return end
	for _, btn in pairs(self.buttons) do
		if x >= btn.buttonX and x <= btn.buttonX + btn.width
			and y >= btn.buttonY and y <= btn.buttonY + btn.height then
			btn:clicked()
		end
	end
end

return Menu
