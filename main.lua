local Player = require 'objects.player'
local Map = require 'systems.map'
local inspect = require 'libs.inspect'
local txt = require 'libs.txt'
local Block = require 'systems.block'
local Tiles = require 'systems.tiles'
local Dungeon = require 'systems.dungeon'
local Game = require 'systems.game-sys.game'
local gamera = require 'libs.gamera'
local Camera 
local world = Game.world

local level = txt.parseMap('levels/level_01.txt')

function love.load()
	
	-- Map:loadMap(level)
	Dungeon:load(15)
end

function love.update(dt)
	Dungeon:generateDungeon(dt, function()
		local x, y = Dungeon:getPointInRandomRoom('random')
		Player:initialize(x-16, y-16, 16, 16)
		local x, y = Dungeon:getBoundaryPoint('close')
		local w, h = Dungeon:getBoundaryPoint('far')
		Camera = gamera.new(x,y,1000, 1000)
		Camera:setWorld(-500, -500, 1750, 1750)
		local cX, cY = Dungeon:getPointInRandomRoom('corner')
		Tiles:createStartingNode(cX, cY)
	end)
	if #Dungeon.rooms > 0 then
		Player:update(dt)
		Camera:setPosition(Player.x, Player.y)
		print(Tiles.nodes.start.x)
	end

end

function love.draw()
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
				Tiles:drawNodes()
			end)
		end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	if key == 'r' then
		-- debug key
	end
end