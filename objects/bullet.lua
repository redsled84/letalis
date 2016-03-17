require "objects/enemy"

bullet = {}
bulletScale = eyeScale / 20 
bullet.width = bulletScale
bullet.height = bulletScale
bullet.speed = 600
k = false
drawBool = false
bul = love.graphics.newImage("img/block.png")

function bullet.Spawn(x, y, direction) 
		table.insert(bullet,{x = x, y = y, direction = direction, width = bullet.width, height = bullet.height} )
end

function bullet.draw()
		for i,v in ipairs(bullet) do
			love.graphics.setColor(255,255,255)
			love.graphics.draw(bul, v.x + anime:getWidth() - bullet.width, v.y + anime:getHeight(), 0, bullet.width / 2, bullet.height / 2)
		end
end

function bullet.path(dt)
	for i,v in ipairs(bullet) do
		v.x = v.x + bullet.speed * dt
	end
end