local Game = require("game")
local Gun = require("gun")

local Hud = {}

function Hud:load()
	self.font = love.graphics.newFont(40)
end

function Hud:update(dt)
end

function Hud:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(self.font)
	love.graphics.print("Score:", 0, 0)
	love.graphics.print(Game.score, 150, 2)
	love.graphics.print("Ammo:", 250, 0)
	love.graphics.print(Gun.ammo, 400, 2)
	love.graphics.print(Game.seconds, love.graphics.getWidth() - 150, 2)
end

return Hud
