local Globals = require 'globals'
local world = Globals.world
local class = require 'libs.middleclass'
local txt = require 'libs.txt'
local Block = require 'systems.block'
local Map = class('Map')

function Map:newMap(x, y, path)
    local map = txt.parseMap(path)
    local x, y = x, y
    for i=1, #map.layers do
        local v = map.layers[i]
        if v.name == "walls" then
            for j=1, #v.data do
                local num = v.data[j]
                -- Loading blocks here but would ideally want to do it seperately
                if num ~= 0 then
                    local block = Block:newBlock({
                    	x = x, 
                    	y = y, 
                    	w = map.tilewidth,
                    	h = map.tileheight, 
                    	is = ''
                    }, world)
                    if num == 1 then
                    	block.is = 'wall'
                    end
                end
                if j % map.w == 0 then
                    x = 0
                    y = y + map.tileheight
                else
                    x = x + map.tilewidth
                end
            end
        end
    end
    return map
end

return Map