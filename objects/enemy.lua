local Enemy = {}

function Enemy:newEnemy(x, y, width, height)
	table.insert(self, {x=x, y=y, width=width, height=height})
end

function Enemy:drawEnemies()
	for i,v in ipairs(self) do
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
	end
end

return Enemy