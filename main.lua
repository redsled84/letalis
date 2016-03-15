local bump = require 'libs.bump'
local Player = require 'objects.player'
local world = bump.newWorld()
local Map = require 'systems.map'
local txt = require 'libs.txt'

local level = txt.parseLevel('levels/level_01.txt')

function love.load()
	Player:initialize(world, 0, 0, 32, 32, other)

end

function love.update(dt)
	
end

function love.draw()
	love.graphics.setColor(255,255,255)
	Player:draw()
	love.graphics.setColor(255,0,0, 100)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	Player:moveWithKeys(key)
end