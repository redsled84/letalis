local class = require 'libs.middleclass'
local Block = class('Block')

function Block:newBlock(o, world)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	world:add(o, o.x, o.y, o.width, o.height)
	return o
end

function Block:removeBlock(item, world)
	world:remove(item)
end

return Block