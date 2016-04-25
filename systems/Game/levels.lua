local Map = require 'systems.map'
local Globals = require 'globals'
local Dungeon = require 'systems.dungeon'
local world = Globals.world
local Levels = {}

function Levels:initialize()
	self.level = {}
end

function Levels:newStaticLevel(path)
	self.level = Map.newMap(0, 0, path)
end

function Levels:newDungeonLevel()
	Dungeon:load(15)
end

function Levels:popLevel()
	self.level = {}
	local items, len = world:getItems()
	for i=1, len do
		local item = items[i]
		world:remove(item)
	end
	Dungeon:initialize()
	self:initialize()
	self:newDungeonLevel()
end

function Levels:moveToLevel(levelType, path)
	self:popLevel()
	if levelType == 'dungeon' then
		Levels:newDungeonLevel()
	elseif levelType == "static" then
		Levels:newStaticLevel(path)
	end 
end

return Levels