local gamera = require 'libs.gamera'
local Game = require 'game'
local tileSize = Game.tileSize
local Dungeon = require 'systems.dungeon'
local Camera = {}

function Camera:initialize()
	local x, y = Dungeon:getBoundryPoint('close')
	local w, h = Dungeon:getBoundryPoint('far')
	self = gamera.new(x, y, w-x, h-y)
end

return Camera