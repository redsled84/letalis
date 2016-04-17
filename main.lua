local Player = require 'objects.player'
local Map = require 'systems.map'
local inspect = require 'libs.inspect'
local txt = require 'libs.txt'
local Block = require 'systems.block'
local Dungeon = require 'systems.dungeon'
local Game = require 'game'
local world = Game.world

local level = txt.parseMap('levels/level_01.txt')

function love.load()
	Player:initialize(0, 0, 32, 32, other)
	Map:loadMap(level)
	Dungeon:load(5)
end

function love.update(dt)
	Player:update(dt)
	Dungeon:generateDungeon(dt)
	for i, v in ipairs(Dungeon.physicsBodies) do
		print(v.x, v.y, i)
	end
	print()
end

function love.draw()
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
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	if key == 'r' then
		-- debug key
	end
end