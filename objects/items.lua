local Items = {items={}}
local potionSprite = love.graphics.newImage('images/POTION_RED.png')
potionSprite:setFilter('nearest', 'nearest')

function Items:newPotion(x, y, potionType)
	if string.lower(potionType) == 'red' then
		local potion = {
			x = x,
			y = y,
			w = potionSprite:getWidth(),
			h = potionSprite:getHeight(),
			sprite = potionSprite,
			is = 'potion'
		}
		table.insert(self.items, potion)
		return potion, i
	end
end
	
function Items:draw()
	for i=1, #self.items do
		love.graphics.setColor(255,255,255)
		love.graphics.draw(self.items[i].sprite, self.items[i].x, self.items[i].y)
	end
end


return Items