local Tiles = require 'systems.tiles'
local Globals = require 'globals'
local Levels = require 'systems.game-sys.levels'
local Game = require 'systems.game-sys.game'
local Player = require 'objects.player'
local Dungeon = require 'systems.dungeon'
local Map = require 'systems.map'

local gamera = require 'libs.gamera'
local world = Game.world

function love.load()
	MenuScreen = love.graphics.newImage('images/MENU_SCREEN.png')
	DiedScreen = love.graphics.newImage('images/DIED_SCREEN.png')
	MenuScreen:setFilter('nearest', 'nearest')
	scaleX = love.graphics.getWidth() / MenuScreen:getWidth()
	scaleY = love.graphics.getHeight() / MenuScreen:getHeight()
	MenuButton = {x = 93*scaleX, y = 84*scaleY, w = (130 - 93)*scaleX, h = (98 - 84)*scaleY}
	opacity = 0
	bgOpacity = 0
	debugOn = false
end

function love.update(dt)
	if Game.state == 'play' then
		Game:updateGame(dt)

		if #Dungeon.rooms > 0 and Player.health < 0 then
			Game.state = 'died'
		end
	end

	if Game.state == 'died' and opacity < 255 then
		opacity = opacity + 200 * dt
	end
	if Game.state == 'died' and bgOpacity < 150 then
		bgOpacity = bgOpacity + 200 * dt
	end 
end

function love.draw()
	if Game.state == 'play' or Game.state == 'died' then
		Game:drawGame()
	elseif Game.state == 'start' then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(MenuScreen, 0, 0, 0, scaleX, scaleY)
	end

	if Game.state == 'died' then
		love.graphics.setColor(0,0,0,bgOpacity)
		love.graphics.rectangle('fill', Camera.l, Camera.t, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(255,255,255, opacity)
		love.graphics.draw(DiedScreen, 0, 0)
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
	if Game.state == 'play' then
		if key == 'r' then
			Levels:popLevel()
		end
	end
	if key == 'tab' then
		debugOn = not debugOn
	end
end