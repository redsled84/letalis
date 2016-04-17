local Game = require 'game'
local world = Game.world
local class = require 'libs.middleclass'
local Block = require 'systems.block'
local Map = class('Map')

function Map:initialize(x, y, map)
    self.x, self.y = x, y
    self.data = {}
    self.map = map
    self.mapwidth, self.mapheight = map.w, map.h 
    self.tilewidth, self.tileheight = map.tilewidth, map.tileheight
end

function Map:loadData()
    local mapwidth = self.mapwidth
    local tilewidth, tileheight = self.tilewidth, self.tileheight
    self.itemCount = 0
    for i=1, #self.map.layers do
        local v = self.map.layers[i]
        if v.name == "walls" then
            for j=1, #v.data do
                local num = v.data[j]
                -- Loading blocks here but would ideally want to do it seperately
                if num ~= 0 then
                    local block = Block:newBlock({
                    	x = self.x, 
                    	y = self.y, 
                    	w = self.tilewidth,
                    	h = self.tileheight, 
                    	is = ''
                    }, world)
                    if num == 1 then
                    	block.is = 'wall'
                    end
                end
                if j % mapwidth == 0 then
                    self.x = 0
                    self.y = self.y + tileheight
                else
                    self.x = self.x + tilewidth
                end
                table.insert(self.data, num)
            end
        end
    end
end

function Map:loadMap(map)
    self:initialize(0, 0, map)
    self:loadData(world)
end

function Map:getTileIndex(x, y)
    local index = y/self.tileheight*self.mapwidth + (x+self.tilewidth)/self.tilewidth
    return index
end

function Map:getMapData()
    return self.data
end

return Map