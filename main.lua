local bump = require 'libs.bump'
local Player = require 'objects.player'
local world = bump.newWorld()
local Map = require 'systems.map'
local inspect = require 'libs.inspect'
local txt = require 'libs.txt'
local Block = require 'systems.block'

local level = txt.parseMap('levels/level_01.txt')

function love.load()
	Player:initialize(world, 0, 0, 32, 32, other)
	Map:loadMap(level, world)
end

function love.update(dt)
	Player:update(dt)
end

function love.draw()
	Player:draw()

	love.graphics.setColor(0,0,255,100)
	-- just drawing world items
	local items, len = world:getItems()
	for i=1, len do
		local item = items[i]
		love.graphics.rectangle("fill", item.x, item.y, item.width, item.height)
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	if key == 'r' then
		-- debug key
	end
	Player:moveWithKeys(key)
end