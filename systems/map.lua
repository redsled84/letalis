local Game = require 'systems.game-sys.game'
local world = Game.world
local class = require 'libs.middleclass'
local txt = require 'libs.txt'
local Block = require 'systems.block'
local Map = class('Map')

function Map:initialize(x, y, map)
    
    
end

function Map:newMap(x, y, path)
    local MAP = txt.parseMap(path)
    map.x, map.y = x, y
    map.data = {}
    map.map = map
    map.mapwidth, map.mapheight = map.w, map.h 
    map.tilewidth, map.tileheight = map.tilewidth, map.tileheight
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
                if j % map.mapwidth == 0 then
                    self.x = 0
                    self.y = self.y + tileheight
                else
                    self.x = self.x + tilewidth
                end
                table.insert(self.data, num)
            end
        end
    end
    return map
end

function Map:loadMap(map)
    self:initialize(0, 0, map)
    self:loadData()
end

return Map