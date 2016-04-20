local bump = require 'libs.bump'
local Levels = require 'systems.game-sys.levels'
local Game = {
	tileSize = 32,
	world = bump.newWorld()	
}

return Game