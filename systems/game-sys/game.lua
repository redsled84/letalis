local Dungeon = require 'systems.dungeon'
local Map = require 'systems.map'
local Player = require 'objects.player'
local Items = require 'objects.items'
local Enemy = require 'objects.enemy'
local Levels = require 'systems.game-sys.levels'
local Globals = require 'globals'

local inspect = require 'libs.inspect'
local bump = require 'libs.bump'
local world = Globals.world
local gamera = require 'libs.gamera'

local Game = {
	tileSize = 32,
	world = bump.newWorld(),
	states = {'start', 'pause', 'play', 'died', 'end'},
	state = 'start',
	drawObjects = {},
	updateCounter = 0
}

function Game:startGame()
	Levels:initialize()
	Levels:newDungeonLevel()
end

function Game:updateGame(dt)
	if Dungeon:getDungeonHasGenerated() then
		Dungeon:generateDungeon(dt, function()
			local x, y = Dungeon:getPointInRandomRoom('random')
			Player:initialize(x-16, y-16, 16, 16)
			local x, y = Dungeon:getBoundaryPoint('close')
			local w, h = Dungeon:getBoundaryPoint('far')
			Camera = gamera.new(0,0,2500, 2500)
			Camera:setWorld(-1000, -1000, 2500, 2500)
			-- local cX, cY = Dungeon:getPointInRandomRoom('corner')
			-- Tiles:createStartingNode(cX, cY)

			for i=1, 6 do
				local x, y = Dungeon:getPointInRandomRoom('random')
				Enemy:newEnemy(x, y, 32, 32, i)
			end
		end)
		if #Dungeon.rooms > 0 then
			Camera:setPosition(Player.x, Player.y)
			Enemy:move(dt)
			Player:update(dt)
			Enemy:kill()
		end
	elseif self.updateCounter < 1 then
		Player:initialize(0, 0, 16, 16)
		Camera = gamera.new(0,0,1000, 1000)
		self.updateCounter = self.updateCounter + 1
	else
		Player:update(dt)
		Camera:setPosition(Player.x, Player.y)
	end
end

function Game:drawGame()
	if Camera ~= nil then
		Camera:draw(function()
			Camera:setScale(2, 2)
			-- drawing world items
			local items, len = world:getItems()
			for i=1, #Dungeon.rooms do
				local room = Dungeon.rooms[i]
				love.graphics.setColor(150,150,150)
				love.graphics.rectangle('fill', room.x, room.y, room.w, room.h)
			end
			for i=1, len do
				local item = items[i]
				if item.is ~= 'chest' and item.is ~= 'potion' and item.is ~= 'enemy' then
					love.graphics.setColor(255,255,0,150)
					love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
					-- love.graphics.setColor(255,255,255)
					-- love.graphics.print(i, item.x, item.y)
				end
			end
			Dungeon:draw()
			Items:draw()
			Enemy:draw()
			Player:draw()
		end)
	end
end

return Game