local bump = require 'libs.bump'
local Player = require 'objects.player'
local world = bump.newWorld()
require "objects.enemy"
require "objects.bullet"
require "objects.drop"

function love.load()
	Player:initialize(world, 0, 0, 32, 32, other)
	local block = {x=100,y=100,width=32,height=32}
	world:add(block, block.x, block.y, block.width, block.height)
end

function love.update(dt)
	Player:update(dt)
	enemyPath(dt)
	eAnime(dt)
	bullet.path(dt)
	deathDrop()
end

function love.draw()
	love.graphics.setBackgroundColor(33,33,33)
	love.graphics.setColor(255,255,255)
	Player:draw()
	love.graphics.setColor(255,0,255)
	enemy.Draw()
	enemy.Hurt()
	love.graphics.setColor(255,255,255)
	bullet.draw()
	drop.Draw()
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	if key == 'k' then
		bullet.Spawn(enemy.x, enemy.y, "right")
	end
	Player:moveWithKeys(key)
	spaceHurt(key)
	--refresh(key)
	if key == 'r' then
		eHealth = 40
		for i=1, #drop do
			drop[i] = false
			print(drop[i], i)
		end
		randomDrop = math.ceil(math.random(1, 4))
	end

end

function love.keyreleased(key)
	
end