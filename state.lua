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
	love.mouse.setVisible(false)
	self.inGame = true
end

return State
