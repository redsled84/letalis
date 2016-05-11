local Globals = require 'globals'
local tileSize = Globals.tileSize
local Items = require 'objects.items'
local Quads = require 'systems.quads'
local chestQuadInfo = Quads:loadQuadInfo(tileSize, tileSize, 4, 1)
local tileset = love.graphics.newImage('images/CHESTS.png')
tileset:setFilter('nearest', 'nearest')
local chestQuads = Quads:loadQuads(chestQuadInfo, tileSize, tileSize, tileset:getWidth(), tileset:getHeight())

local Chests = { quads = chestQuads }

function Chests:newChest(x, y, chestType)
	local chest = {
		x = x,
		y = y,
		w = tileSize,
		h = tileSize,
		inventory = {
			-- Items:newPotion(x, y, 'red')
		},
		spriteNum = 1,
		chestType = chestType,
		opened = false,
		is = 'chest'
	}

	return chest
end

function Chests:draw(chest)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(tileset, self.quads[chest.spriteNum], chest.x, chest.y)
end

return Chests