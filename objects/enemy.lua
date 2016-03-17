
enemy = {}
enemy.x = 10  
enemy.y = 10
eHealth = 40
ePath = 100
timer = 0
animation = {"img/eye_Bounce_0.png", "img/eye_Bounce_1.png", "img/eye_Bounce_2.png", "img/eye_Bounce_3.png",
			"img/eye_Bounce_4.png"}
anime = love.graphics.newImage(animation[1])
enum = 1
hFull = love.graphics.newImage("img/health01.png")
hThreeQuarter = love.graphics.newImage("img/health02.png")
hHalf = love.graphics.newImage("img/health03.png")
hQuarter = love.graphics.newImage("img/health04.png")
hDead = love.graphics.newImage("img/health05.png")
health = {hFull, hThreeQuarter, hHalf, hQuarter, hDead}
eyeScale = 2
eDir = eyeScale
eyeHealthScale = eyeScale
eyeYscale = eyeHealthScale * .6


function enemy.Draw()
	love.graphics.setColor(255,255,255)
	if ePath < 0 then
		love.graphics.draw(anime, enemy.x+anime:getWidth()*eDir, enemy.y, 0, -eDir, eyeScale)
	elseif ePath > 0 then
		love.graphics.draw(anime, enemy.x, enemy.y, 0, eDir, eyeScale)
	end
end

function enemy.Hurt()
	if eHealth == 40 then
		love.graphics.draw(hFull, enemy.x, enemy.y-8, 0, eyeHealthScale, eyeYscale)
	elseif eHealth == 30 then
		love.graphics.draw(hThreeQuarter, enemy.x, enemy.y-8, 0, eyeHealthScale, eyeYscale)
	elseif eHealth == 20 then
		love.graphics.draw(hHalf, enemy.x, enemy.y-8, 0, eyeHealthScale, eyeYscale)
	elseif eHealth == 10 then
		love.graphics.draw(hQuarter, enemy.x, enemy.y-8, 0, eyeHealthScale, eyeYscale)
	elseif eHealth <= 0 then
		love.graphics.draw(hDead, enemy.x, enemy.y-8, 0, eyeHealthScale, eyeYscale)
	end
	for i = 1, #health do 
		health[i]:setFilter("nearest", "nearest")
	end
end

function enemyPath(dt)
	enemy.x = enemy.x + ePath * dt

	if enemy.x >= 500 then
		ePath = -ePath
	elseif enemy.x <= 2 then
		ePath = -ePath
	end
end

function eAnime(dt)
	timer = timer + dt
	anime = love.graphics.newImage(animation[enum])
	if timer > .1 then
		timer = 0
		enum = enum + 1
	end
	if enum > #animation then
		enum = 1
	end
	anime:setFilter("nearest", "nearest")
end

function spaceHurt(key)
	if key == 'space' then 
		eHealth = eHealth - 10
	end
end

function refresh(key)
	if key == 'r' then
		eHealth = 40
	end	
end

