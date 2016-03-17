require "objects.enemy"

math.randomseed(os.time())
randomDrop = math.ceil(math.random(1, 4))
drop = {}
drop.a = false
drop.b = false
drop.c = false
drop.d = false
dropTest = love.graphics.newImage("img/block.png")

function deathDrop()
	if eHealth <= 0 then
		if randomDrop == 1 then 
			drop.a = true
		elseif randomDrop == 2 then
			drop.b = true
		elseif randomDrop == 3 then
			drop.c = true
		elseif randomDrop == 4 then
			drop.d = true
		end
	else 
		drop.a = false
		drop.b = false
		drop.c = false
		drop.d = false
	end
end

function drop.Draw()
	if drop.a == true then
		love.graphics.draw(dropTest, 10, 10)
	end
	if drop.b == true then
		love.graphics.draw(dropTest, 10, 500)
	end
	if drop.c == true then
		love.graphics.draw(dropTest, 500, 10)
	end
	if drop.d == true then
		love.graphics.draw(dropTest, 500, 500)
	end
end