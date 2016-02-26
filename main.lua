local bump = require 'libs.bump'
local Player = require 'objects.player'
local world = bump.newWorld()
local bullet = require 'objects.bullet'
local Enemy = require 'objects.enemy'
local collide = require 'collide'

function love.load()
	Player:initialize(world, 0, 0, 32, 32, other)

	local block = {x=100,y=100,width=32,height=32}
	world:add(block, block.x, block.y, block.width, block.height)

	local x = 96
	local y = 96
	for i=1, 5 do
		Enemy:newEnemy(x, y, 32, 32)
		x = x + 32
		y = y + 64
	end

end

function love.update(dt)
	Player:update(dt)
	for i,v in ipairs(Enemy) do
		local enemy = v
		collide.check(Player.other.radius, enemy, function () 
			print("Fuck you Tyler jk I love you boo", i)
		end)
	end
end

function love.draw()
	love.graphics.setColor(255,255,255)
	Player:draw()
	love.graphics.setColor(255,0,0, 100)
	Enemy:drawEnemies()
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	Player:moveWithKeys(key)
end