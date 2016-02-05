local class = require 'libs.middleclass'
local Player = class('Player')

local other = { speed=32, dx=0, dy=0, radius=2 }

function Player:initialize(world, x, y, width, height)
	self.x, self.y = x, y
	self.world = world
	self.width, self.height = width, height
	self.other = other
	self.world:add(self, x, y, width, height)
end

function Player:collision()
	local world = self.world
	local dx, dy = self.other.dx, self.other.dy
	if dx ~= 0 or dy ~= 0 then
	    local cols
	    self.x, self.y, cols, cols_len = world:move(self, self.x + dx, self.y + dy)
	    for i=1, cols_len do
	      local col = cols[i]
	      consolePrint(("col.other = %s, col.type = %s, col.normal = %d,%d"):format(col.other, col.type, col.normal.x, col.normal.y))
	    end
    end	
end

function Player:checkRadius()

end

function Player:update(dt)
	Player:collision()
end

function Player:moveWithKeys(key)
	self.other.dx, self.other.dy = 0, 0
	if key == 'd' then
		self.other.dx = self.other.dx + self.other.speed
	elseif key == 'a' then
		self.other.dx = self.other.dx - self.other.speed
	elseif key == 'w' then
		self.other.dy = self.other.dy - self.other.speed
	elseif key == 's' then
		self.other.dy = self.other.dy + self.other.speed
	end
	print(self.other.dx)
end

function Player:draw()
	local lg = love.graphics
	lg.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Player