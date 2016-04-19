local Game = require 'game'
local tileSize = Game.tileSize
local bumpWorld = Game.world
local Physics = require 'libs.physics'
local Block = require 'systems.block'
local polyfill = require 'libs.polyfill'
local physicsWorld = love.physics.newWorld(); love.physics.setMeter(64)
local class = require 'libs.middleclass'
local inspect = require 'libs.inspect'
local Dungeon = class('Dungeon')

math.randomseed(os.time()); math.random(); math.random(); math.random()

-- NEED to split rooms, doors, physicsBodies, into different sub classes of Dungeon

function Dungeon:initialize()
	self.rooms = {}
	self.doors = {}
	self.physicsBodies = {}
	self.physicsWorld = physicsWorld
	self.touchingLines = {}
end


function Dungeon:getPhysicsBodiesIsSleep()
	local counter = 0
	for i,v in ipairs(self.physicsBodies) do
		if not v.body:isAwake() then
			counter = counter + 1
		end
	end

	if counter == #self.physicsBodies then
		return true
	end
end


function Dungeon:insertRooms()
	for i=1, #self.physicsBodies do
		local v = self.physicsBodies[i]
		table.insert(self.rooms, {x = v.x , y = v.y , w = v.w, h = v.h, id=i})
	end
end


function Dungeon:loopRooms(f)
	local temp = polyfill.shallowCopy(self.rooms)
	for i=1, #self.rooms do
		table.remove(temp, i)
		local room = self.rooms[i]
		local A = {
			x1 = room.x,
			y1 = room.y,
			x2 = room.x+room.w,
			y2 = room.y+room.h
		}
		for j=1, #temp do
			local tempRoom = temp[j]
			local B = {
				x1 = tempRoom.x,
				y1 = tempRoom.y,
				x2 = tempRoom.x+tempRoom.w,
				y2 = tempRoom.y+tempRoom.h
			}
			if room.id < tempRoom.id then
				break
			else
				f(A, B, room, tempRoom)
			end
		end
		temp = polyfill.shallowCopy(self.rooms)
	end
end


function Dungeon:generateDoors()
	self:loopRooms(function(A, B, room, tempRoom)
		if A.x2 == B.x1 and A.y1 == B.y2 or -- A's top right corner touches B's bottom left corner
			A.x1 == B.x2 and A.y1 == B.y2 or -- A's top left corner touches B's bottom right corner
			A.x1 == B.x2 and A.y2 == B.y1 or -- A's bottom left corner touches B's top right corner
			A.x2 == B.x1 and A.y2 == B.y1 then -- A's bottom right corner touches B's top left corner
				-- empty because I don't want the corners to count as 'touching'
		else
			if A.x1 - 1 < B.x2 and A.x2 + 1 > B.x1 and A.y1 - 1 < B.y2 and A.y2 + 1 > B.y1 then
				if A.y1 + 1 < B.y2 and A.y2 - 1 > B.y1 then	
					local x, y1, y2 = 0, 0, 0
					y1, y2 = polyfill.setPosition(A.y1, A.y2, B.y1, B.y2)

					if A.x2 > B.x1 - 1 and A.x2 < B.x2 then -- A is touching B's LEFT wall
						x = B.x1
					elseif A.x1 < B.x2 + 1 and A.x1 > B.x1 then -- A is touching B's RIGHT wall
						x = B.x2
					end

					if math.abs(y2 - y1) >= tileSize then
						local doorY = 0
						if math.abs(y2 - y1) - tileSize == 0 or math.abs(y2 - y1) == tileSize then
							doorY = y1
						else
							doorY = (math.random(0, (y2-y1-tileSize)/tileSize) * tileSize) + y1
						end
						self.doors[#self.doors+1] = {x=x-tileSize, y=doorY, w=tileSize, h=tileSize, isSide=true}
					end

					self.touchingLines[#self.touchingLines+1] = {x = x, y1 = y1, y2 = y2}
				end
				if A.x1 + 1 < B.x2 and A.x2 - 1 > B.x1 then
					local y, x1, x2 = 0, 0, 0
					x1, x2 = polyfill.setPosition(A.x1, A.x2, B.x1, B.x2)
					if A.y2 > B.y1 - 1 and A.y2 < B.y2 then -- A is touching B's TOP wall
						y = B.y1
					elseif A.y1 < B.y2 + 1 and A.y1 > B.y1 then -- A is touching B's BOTTOM wall
						y = B.y2
					end
					if math.abs(x2 - x1) >= tileSize then
						local doorX = 0
						if math.abs(x2 - x1) - tileSize == 0 or math.abs(x2 - x1) == tileSize then
							doorX = x1
						else
							doorX = (math.random(0, (x2-x1-tileSize)/tileSize) * tileSize) + x1
						end
						self.doors[#self.doors+1] = {x=doorX, y=y-tileSize, w=tileSize, h=tileSize, isSide=false}
					end

					self.touchingLines[#self.touchingLines+1] = {y = y, x1 = x1, x2 = x2}
				end
			end
		end
	end)
end


function Dungeon:getBoundaryPoint(type)
	local cX = {}
	local cY = {}
	for i=1, #self.rooms do
		local room = self.rooms[i]
		cX[#cX+1] = room.x
		cY[#cY+1] = room.y
	end
	table.sort(cX)
	table.sort(cY)
	if type == 'close' then
		return cX[1], cY[1]
	elseif type == 'far' then
		return cX[#cX], cY[#cY]
	end
end


function Dungeon:getPointInRandomRoom(type)
	local rndIndex = math.random(1, #self.rooms)
	local rndRoom = self.rooms[rndIndex]
	local rndRoomX, rndRoomY
	if type == 'random' then
		rndRoomX = math.random(2, rndRoom.w/tileSize-1)
		rndRoomY = math.random(2, rndRoom.h/tileSize-1)
	elseif type == 'corner' then
		rndRoomX = 1
		rndRoomY = 1 
	end
	return rndRoom.x + rndRoomX*tileSize, rndRoom.y + rndRoomY*tileSize
end


function Dungeon:load(n)
	self:initialize()
	for i=1, n do
		self.physicsBodies[i] = Physics:createRectangle(self.physicsWorld, math.random(375,400),math.random(375,400),math.random(7,12)*tileSize,math.random(7,12)*tileSize)
		local v = self.physicsBodies[i]
		v.body:setFixedRotation(true)
	end
end


function Dungeon:generateBlocks()
	-- append blocks for each room
	for i=1, #self.rooms do
		local room = self.rooms[i]
		for j=0, room.w/tileSize-1 do
			local x = room.x+j*tileSize
			Block:newBlock({x = x, y = room.y, w = tileSize, h = tileSize})
			Block:newBlock({x = x, y = room.y+(room.h/tileSize-1)*tileSize, w = tileSize, h = tileSize})
		end

		for j=1, room.h/tileSize-2 do
			local y = room.y+j*tileSize
			Block:newBlock({x = room.x, y = y, w = tileSize, h = tileSize})
			Block:newBlock({x = room.x+(room.w/tileSize-1)*tileSize, y = y, w = tileSize, h = tileSize})
		end
	end

	-- filter each block
	local items, len = Block:getWorldItems()
	for i=1, len do
		local block = items[i]
		if block.x ~= nil then
			for j=1, #self.doors do
				local door = self.doors[j]
				if door.x == block.x and door.y == block.y then
					Block:remove(door.x, door.y)
					if not door.isSide then
						Block:remove(door.x, door.y+tileSize)
					else
						Block:remove(door.x+tileSize, door.y)
					end
				end
			end
		end			
	end
end


function Dungeon:generateRooms()
	if self:getPhysicsBodiesIsSleep() and #self.physicsBodies > 0 then
		self:insertRooms()
		self:generateDoors()
		self:generateBlocks()
		for i=#self.physicsBodies,1,-1 do
			local v = self.physicsBodies[i]
			v.body:destroy()
			table.remove(self.physicsBodies, i)
		end

	end
end


function Dungeon:generateDungeon(dt, event)
	if self:getPhysicsBodiesIsSleep() and #self.physicsBodies > 0 then
		for i, v in ipairs(self.physicsBodies) do
			v.x, v.y = v.body:getWorldPoints(v.shape:getPoints())
			v.x = v.x - v.x % tileSize
			v.y = v.y - v.y % tileSize
		end
		self:generateRooms()
		event()
	end
	self.physicsWorld:update(dt)
end


function Dungeon:draw()
	for _,v in ipairs(self.physicsBodies) do
		love.graphics.setColor(0,0,255)
		love.graphics.polygon("line", v.body:getWorldPoints(v.shape:getPoints()))
		love.graphics.setColor(0,0,255,100)
		love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
	end

	for _,v in ipairs(self.rooms) do
		love.graphics.setColor(150,150,150)
		love.graphics.rectangle('line', v.x, v.y, v.w, v.h)
		love.graphics.setColor(230, 230, 230, 100)
		love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
	end

	for _, v in ipairs(self.doors) do
		love.graphics.setColor(255,0,0)
		love.graphics.rectangle('line', v.x, v.y, v.w, v.h)
	end

	for _, v in ipairs(self.touchingLines) do
		love.graphics.setColor(0,255,0)
		if v.x ~= nil then
			love.graphics.line(v.x, v.y1, v.x, v.y2)
		else
			love.graphics.line(v.x1, v.y, v.x2, v.y)
		end
	end
end

return Dungeon