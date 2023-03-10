local love = require("love")
local State = {}
--gameState needs to be accessible everywhere

function State:load()
	self.inGame = false
	self.mainMenu = true
	self.score = false
end

function State:clear()
	self.inGame = false
	self.mainMenu = false
	self.score = false
end

function State:startGame()
	self:clear()
	self.inGame = true
end

function State:endGame()
	self:clear()
	self.score = true
end

return State
