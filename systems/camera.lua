local gamera = require 'libs.gamera'
local Globals = require 'globals'
local tileSize = Globals.tileSize
local Dungeon = require 'systems.dungeon'
local Camera = {}

function Camera:initialize()
	local x, y = Dungeon:getBoundryPoint('close')
	local w, h = Dungeon:getBoundryPoint('far')
	self = gamera.new(x, y, w-x, h-y)
end

return Camera