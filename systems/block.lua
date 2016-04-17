local Game = require 'game'
local world = Game.world
local class = require 'libs.middleclass'
local Block = class('Block')

function Block:newBlock(o)
	world:add(o, o.x, o.y, o.w, o.h)
	return o
end

function Block:getBlockIndex(x, y)
	local items, len = world:getItems()
	local blocks = {}
	for i=1, len do
		local v = items[i]
		if v.x == x and v.y == y and v.is == 'wall' then
			blocks[#blocks+1] = v
		end
	end
	return blocks
end

function Block:removeBlock(item)
	world:remove(item)
end

function Block:remove(x, y)
	local blocks = self:getBlockIndex(x, y)
	for i=1, #blocks do
		self:removeBlock(blocks[i])
	end
end

function Block:getWorldItems()
	local items, len = world:getItems()
	return items, len
end

return Block