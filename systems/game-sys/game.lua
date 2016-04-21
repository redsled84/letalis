local Dungeon = require 'systems.dungeon'
local Map = require 'systems.map'
local Player = require 'objects.player'
local Levels = require 'systems.game-sys.levels'
local Globals = require 'globals'
local Camera

local inspect = require 'libs.inspect'
local bump = require 'libs.bump'
local world = Globals.world
local gamera = require 'libs.gamera'

local Game = {
	tileSize = 32,
	world = bump.newWorld(),
	states = {'start', 'pause', 'play', 'died', 'end'},
	state = 'play',
	drawObjects = {}
}

function Game:startGame(path)
	Levels:initialize()
	Levels:newDungeonLevel()
	-- Levels:newStaticLevel(path)
end

function Game:updateGame(dt)
	Dungeon:generateDungeon(dt, function()
		local x, y = Dungeon:getPointInRandomRoom('random')
		Player:initialize(x-16, y-16, 16, 16)
		local x, y = Dungeon:getBoundaryPoint('close')
		local w, h = Dungeon:getBoundaryPoint('far')
		Camera = gamera.new(x,y,1000, 1000)
		Camera:setWorld(-500, -500, 1750, 1750)
		-- local cX, cY = Dungeon:getPointInRandomRoom('corner')
		-- Tiles:createStartingNode(cX, cY)
	end)
	if #Dungeon.rooms > 0 then
		Player:update(dt)
		Camera:setPosition(Player.x, Player.y)
	end
end

function Game:drawGame()
	if #Dungeon.rooms > 0 then
		Camera:draw(function()
			Player:draw()
			-- drawing world items
			local items, len = world:getItems()
			for i=1, len do
				local item = items[i]
				love.graphics.setColor(0,0,255,100)
				love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
				love.graphics.setColor(255,255,255)
				love.graphics.print(i, item.x, item.y)
			end

			Dungeon:draw()
		end)
	end
end

return Game