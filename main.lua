local bump = require 'libs.bump'
local Player = require 'objects.player'
local world = bump.newWorld()
local Enemy = require 'objects.enemy'
local Block = require 'objects.block'
local collide = require 'collide'

function love.load()
	Player:initialize(world, 0, 0, 32, 32, other)

	block = Block:newBlock({x=32*8,y=32*3,width=32,height=32, is="stuff"}, world)

	local x = 96
	local y = 96
	for i=1, 5 do
		Enemy:newEnemy(x, y, 32, 32)
		x = x + 32
		y = y + 64
	end

end

function love.update(dt)
	Player:update(dt, world, function(item, world) 
		Blocks:remove(item, world)
	end)
	for i,v in ipairs(Enemy) do
		local enemy = v
		collide.check(Player.other.radius, enemy, function () 
			-- insert enemy shtuff here
		end)
	end
end

function love.draw()
	love.graphics.setColor(255,255,255)
	Player:draw()
	love.graphics.setColor(255,0,0, 100)
	Enemy:drawEnemies()
	love.graphics.rectangle("line", block.x, block.y, block.width, block.height)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	Player:moveWithKeys(key)
end