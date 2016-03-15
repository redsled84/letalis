local Bullet = {}

function Bullet.spawn(x, y, width, height)
	table.insert(Bullet, {x=x,y=y,width=width,height=height})
end

function Bullet.update(dt)
	for i, v in ipairs(Bullet) do
		v.x = v.x + 300 * dt
	end
end

function Bullet.draw()
	for i,v in ipairs(Bullet) do
		love.graphics.rectangle('fill', v.x, v.y, v.width, v.height)
	end
end

return Bullet