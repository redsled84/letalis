local Tiles = require 'systems.tiles'
local Globals = require 'globals'
local Levels = require 'systems.game-sys.levels'
local Game = require 'systems.game-sys.game'
local Map = require 'systems.map'
local Camera 

local gamera = require 'libs.gamera'
local world = Game.world

function love.load()
	MenuScreen = love.graphics.newImage('images/MENU_SCREEN.png')
	MenuScreen:setFilter('nearest', 'nearest')
	scaleX = love.graphics.getWidth() / MenuScreen:getWidth()
	scaleY = love.graphics.getHeight() / MenuScreen:getHeight()
	MenuButton = {x = 93*scaleX, y = 84*scaleY, w = (130 - 93)*scaleX, h = (98 - 84)*scaleY}
end

function love.update(dt)
	if Game.state == 'play' then
		Game:updateGame(dt)
	end
end

function love.draw()
	if Game.state == 'play' then
		Game:drawGame()
	elseif Game.state == 'start' then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(MenuScreen, 0, 0, 0, scaleX, scaleY)
	end
end

function love.mousepressed(x, y, button)
	if Game.state == 'start' then
		if button == 1 and x > MenuButton.x and x < MenuButton.x+MenuButton.w and y > MenuButton.y and y < MenuButton.y+MenuButton.h then
			Game.state = 'play'
			Game:startGame()
		end
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	if key == 'r' then
		Levels:popLevel()
	end
end