local inspect = require 'libs.inspect'
local class = require 'libs.middleclass'
local Game = require 'game'
local world = Game.world
local Player = class('Player')

function Player:initialize(x, y, w, h)
	self.x, self.y = x, y
	self.w, self.h = w, h
	self.spd = 256
	self.vx, self.vy = 0, 0
	self.radius = 100
	world:add(self, x, y, w, h)
end

local function collisionFilter(item, other)
	if other.is == "item" then
		return 'cross'
	else
		return 'slide'
	end
end

function Player:movement(dt)
	local lk = love.keyboard

	if lk.isDown('d') then
		self.vx = self.vx + self.spd * dt
	end
	if lk.isDown('a') then
		self.vx = self.vx - self.spd * dt
	end
	if lk.isDown('s') then
		self.vy = self.vy + self.spd * dt
	end
	if lk.isDown('w') then
		self.vy = self.vy - self.spd * dt	
	end

	self.x, self.y = self.x+self.vx*dt, self.y+self.vy*dt
	-- print(x, y, self.x, self.y)
	world:update(self, self.x, self.y)
	-- didn't even get to work on the dungeons , do dungeons

	-- need to make the physics bodies asleep, then generate rooms, find touching sides, generate doors
end

function Player:collision()
	local actualX, actualY, cols, len = world:move(self, self.x, self.y, collisionFilter)
	for i=1, len do
		local v = cols[i]
		if v.type == 'slide' then
			if v.normal.x == -1 then 
				self.x = v.other.x-self.w
				self.vx = 0
			end
			if v.normal.x == 1 then
				self.x = v.other.x+v.other.w
				self.vx = 0
			end
			if v.normal.y == -1 then
				self.y = v.other.y-self.h
				self.vy = 0
			end
			if v.normal.y == 1 then
				self.y = v.other.y+v.other.h
				self.vy = 0
			end
		else
			world:remove(v.other)
		end
	end
end

function Player:setPosition(x, y)
	self.x, self.y = x, y
	world:update(self, self.x, self.y)
end

function Player:getCenter()
	return self.x+self.w/2, self.y+self.h/2
end

function Player:update(dt)
	Player:collision()
	Player:movement(dt)
end

function Player:draw()
	local lg = love.graphics
	local x, y = self:getCenter()
	lg.setColor(255,255,255)
	lg.rectangle('fill', self.x, self.y, self.w, self.h)
	lg.circle('line', x, y, self.radius)
end

return Player