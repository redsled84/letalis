local bullet = {}

function bullet.spawn(x, y, width, height)
	table.insert(bullet, {x=x,y=y,width=width,height=height})
end

function bullet.update(dt)
	for i, v in ipairs(bullet) do
		v.x = v.x + 300 * dt
	end
end

function bullet.draw()
	for i,v in ipairs(bullet) do
		love.graphics.rectangle('fill', v.x, v.y, v.width, v.height)
	end
end

return bullet