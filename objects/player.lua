local inspect = require 'libs.inspect'
local class = require 'libs.middleclass'
local Items = require 'objects.items'
local Enemy = require 'objects.enemy'
local Block = require 'systems.block'
local Globals = require 'globals'
local world = Globals.world
local Player = class('Player')
local polyfill = require 'libs.polyfill'

function Player:initialize(x, y, w, h)
	self.x, self.y = x, y
	self.w, self.h = w, h
	self.spd = 600
	self.vx, self.vy = 0, 0
	self.radius = 100
	self.health = 100
	self.maxHealth = 100
	self.itemCounter = 0
	world:add(self, x, y, w, h)
end

local function collisionFilter(item, other)
	if other.is == 'potion' then
		return 'cross'
	else
		return 'slide'
	end
end

function Player:movement(dt)
	local lk = love.keyboard

	if lk.isDown('d') then
		self.vx = polyfill.approach(self.vx, self.spd *dt, 300)
	elseif lk.isDown('a') then
		self.vx = polyfill.approach(self.vx, self.spd *dt, -300)
	else
	    self.vx = polyfill.approach(self.vx, self.spd *dt *2, 0)
	end

	if lk.isDown('s') then
		self.vy = polyfill.approach(self.vy, self.spd *dt, 300)
	elseif lk.isDown('w') then
		self.vy = polyfill.approach(self.vy, self.spd *dt, -300)
	else
		self.vy = polyfill.approach(self.vy, self.spd *dt *2, 0)
	end

	self.x, self.y = self.x+self.vx *dt, self.y+self.vy *dt
	-- print(x, y, self.x, self.y)
	world:update(self, self.x, self.y)
	-- didn't even get to work on the dungeons , do dungeons

	-- need to make the physics bodies asleep, then generate rooms, find touching sides, generate doors
end

function Player:addHealth(amount)
	if self.health + amount > self.maxHealth then
		self.health = self.maxHealth
	else
		self.health = self.health + amount
	end
end

function Player:collision(dt)
	local actualX, actualY, cols, len = world:move(self, self.x, self.y, collisionFilter)
	for i=len, 1, -1 do
		local v = cols[i]
		if v.type == 'slide' then
			if v.other.chestType == 'iron' and v.other.opened == false then
				v.other.spriteNum = 4
				local potion, i = Items:newPotion(v.other.x+v.other.w/2, v.other.y+v.other.h, 'red')
				potion.index = i
				Block:newBlock(potion)
				v.other.opened = true
			end

			if v.other.is == 'enemy' then
				if self.health > 0 then
					self.health = self.health - 200 * dt
				end
				local dis = polyfill.dis(self, v.other)
				if dis < self.radius and love.keyboard.isDown('space') then
					v.other.health = math.floor(v.other.health - 200 * dt)
				end

				if v.other.health < 0 then
					Block:removeBlock(v.other)
				end
			end

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
			self:addHealth(25)
			table.remove(Items.items, v.other.index)
			Block:removeBlock(v.other)
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
	Player:collision(dt)
	Player:movement(dt)
end

function Player:draw()
	local lg = love.graphics
	local x, y = self:getCenter()
	lg.setColor(255,255,255)
	lg.rectangle('fill', self.x, self.y, self.w, self.h)
	-- lg.circle('line', x, y, self.radius)
	if self.health > 0 then
		lg.setColor(0,255,0)
		lg.rectangle('fill', self.x-self.w*2.5,self.y-20, self.health, 12)
	end	
	lg.setColor(255,255,255)
	lg.rectangle('line', self.x-self.w*2.5,self.y-20, 100, 12)
	lg.print(tostring(math.floor(self.health)) .. ' / ' .. tostring(self.maxHealth), self.x-self.w, self.y-20)
end

return Player