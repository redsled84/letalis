local collide = require 'collide'
local inspect = require 'libs.inspect'
local class = require 'libs.middleclass'
local Player = class('Player')

local other = { 
	speed=32, 
	dx=0, 
	dy=0, 
	radius= {
		size=1, 
		x=0,
		y=0,
		width=0,
		height=0
	} 
}

function Player:initialize(world, x, y, width, height)
	self.x, self.y = x, y
	self.world = world
	self.width, self.height = width, height
	self.other = other
	self.world:add(self, x, y, width, height)
end

local function collisionFilter(item, other)
	if other.is == "block" then
		return 'cross'
	else
		return 'slide'
	end
end

function Player:collision(f)
	local world = self.world
	local actualX, actualY, cols, len = world:move(self, self.x, self.y, collisionFilter)
	for i=1, len do
		local v = cols[i]
		if v.type == 'slide' then
			if v.normal.x == -1 then
				self.x = v.other.x - self.width
			elseif v.normal.x == 1 then
				self.x = v.other.x + v.other.width
			end
			if v.normal.y == -1 then
				self.y = v.other.y - self.height
			elseif v.normal.y == 1 then
				self.y = v.other.y + v.other.height
			end
		else
			f(col.other, world)
		end
	end
end

function Player:setRadius()
	local size = self.other.radius.size
	self.other.radius.x = self.x-size*self.width
	self.other.radius.y = self.y-size*self.height

	self.other.radius.width = size*2*self.width+self.width
	self.other.radius.height = size*2*self.height+self.height
end

function Player:setPosition(x, y)
	self.x, self.y = x, y
end

function Player:getCenter()
	return self.x+self.width/2, self.y+self.height/2
end

function Player:update(dt, f)
	Player:collision(f)
	Player:setRadius()
end

function Player:moveWithKeys(key)
	self.other.dx, self.other.dy = 0, 0
	if key == 'd' then
		self.other.dx = self.other.speed
	elseif key == 'a' then
		self.other.dx = -self.other.speed
	elseif key == 'w' then
		self.other.dy = -self.other.speed
	elseif key == 's' then
		self.other.dy = self.other.speed
	end
	self.x = self.x + self.other.dx
	self.y = self.y + self.other.dy
end

function Player:draw()
	local lg = love.graphics
	local radius = self.other.radius
	lg.rectangle('fill', self.x, self.y, self.width, self.height)
	lg.rectangle('line', self.other.radius.x, self.other.radius.y,
		self.other.radius.width, self.other.radius.height)
end

return Player