local cron = require 'cron'

local target = {}

function load_game()
	target.radius = 50
	math.randomseed(os.time()) --random number seeding is required
	target.x, target.y = positionTarget(target)

	score = 0
	seconds = 0
	ammo = 6
	timer = cron.every(1, function() seconds = seconds + 1 end) 
	initialtime = love.timer.getTime()
	font = love.graphics.newFont(40)
end

function love.mousepressed( x, y, button, istouch, presses )
	if button == 1 and ammo > 0 then
		if distanceBetween(x, y, target.x, target.y) <= target.radius then
			score = score + 1
			target.x, target.y = positionTarget()
		end
		ammo = ammo - 1
	end
end

function positionTarget()
	x = math.random(target.radius, love.graphics.getWidth() - target.radius)
	y = math.random(target.radius, love.graphics.getHeight() - target.radius)
	return x, y
end

function distanceBetween(mouseX, mouseY, targetX, targetY)
	return math.sqrt( math.pow((mouseX - targetX), 2) + math.pow((mouseY - targetY), 2) )
end

function round(num)
	return num + (2^52 + 2^51) - (2^52 + 2^51)
end
	
function update_game(dt)
	timer:update(dt)
end

function draw_game_target()
	love.graphics.setColor(love.math.colorFromBytes(0, 153, 0))
	love.graphics.circle("fill", target.x, target.y, target.radius)
end

function draw_game_hud()
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(font)
	love.graphics.print("Score:", 0, 0)
	love.graphics.print(score, 150, 2)
	love.graphics.print(seconds, love.graphics.getWidth() - 150, 2)
end

function draw_game()
	draw_game_target()
	draw_game_hud()
end

--called when the game starts. Handles all the setup stuff
function love.load()
	game_state = 0
	if game_state == 0 then
		load_game()
	end
end

--called 60 times per second. Handles the main game loop
function love.update(dt)
	if game_state == 0 then
		update_game(dt)
	end
end

--called 60 times per second. Handles graphical elements of the game
function love.draw()
	if game_state == 0 then
		draw_game()
	end
end
