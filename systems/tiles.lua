local Game = require 'systems.game-sys.game'
local tileSize = Game.tileSize
local Tiles = {}

function Tiles:createStartingNode(x, y)
	self.nodes = {}
	self.nodes.start = {x = x, y = y}
end

function Tiles:drawNodes()
	love.graphics.setColor(0,255,255)
	love.graphics.rectangle('line', self.nodes.start.x, self.nodes.start.y, tileSize, tileSize)
end

return Tiles