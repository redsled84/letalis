local bump = require 'libs.bump'
local Player = require 'objects.player'
local world = bump.newWorld()

function love.load()
	Player:initialize(world, 0, 0, 32, 32, other)
	print(Player.x)

	local block = {x=100,y=100,width=32,height=32}
	world:add(block, block.x, block.y, block.width, block.height)
end

function love.update(dt)
	Player:update(dt)
end

function love.draw()
	Player:draw()
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	Player:moveWithKeys(key)
end