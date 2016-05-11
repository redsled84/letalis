local Block = require 'systems.block'
local Globals = require 'globals'
local world = Globals.world

local Enemy = {enemies = {}}
local enemySprites = {
	"images/eye_Bounce_0.png", 
	"images/eye_Bounce_1.png", 
	"images/eye_Bounce_2.png", 
	"images/eye_Bounce_3.png",
	"images/eye_Bounce_4.png"
}

function Enemy:newEnemy(x, y, w, h, i)
	local enemy = {
		x=x, 
		y=y, 
		w=w, 
		h=h, 
		sprite = love.graphics.newImage(enemySprites[1]),
		spriteNum = 1,
		spriteTimer = 0,
		health = 50,
		maxHealth = 50,
		paths = {
			A = {
				x = x-32,
				y = y
			},
			B = {
				x = x+32,
				y = y
			}
		},
		spd = 100,
		is = 'enemy',
		index = i or 0
	}
	Block:newBlock(enemy, x, y, w, h)
	table.insert(self.enemies, enemy)
end

function Enemy:move(dt)
	for i=1, #self.enemies do
		local enemy = self.enemies[i]
		enemy.x = enemy.x + enemy.spd * dt

		if enemy.x >= enemy.paths.B.x or enemy.x <= enemy.paths.A.x then
			enemy.spd = -enemy.spd
		end

		world:update(enemy, enemy.x, enemy.y)
	end
end

function Enemy:kill()
	for i=#self.enemies, 1, -1 do
		local enemy = self.enemies[i]
		if enemy.health < 0 then
			Block:remove(enemy)
			table.remove(self.enemies, i)
		end
	end
end

function Enemy:animate()
	local dt = love.timer.getDelta()
	for i,v in ipairs(self.enemies) do
		v.spriteTimer = v.spriteTimer + dt
		v.sprite = love.graphics.newImage(enemySprites[v.spriteNum])
		if v.spriteTimer > .1 then
			v.spriteTimer = 0
			v.spriteNum = v.spriteNum + 1
		end
		if v.spriteNum > #enemySprites then
			v.spriteNum = 1
		end
		v.sprite:setFilter("nearest", "nearest")
	end
end

function Enemy:draw()
	local lg = love.graphics
	for i,v in ipairs(self.enemies) do
		lg.setColor(255,255,255)
		lg.draw(v.sprite, v.x, v.y)
		lg.setColor(0,255,0)
		lg.rectangle('fill', v.x-v.w/2.15,v.y-20, v.health, 12)
		lg.setColor(255,255,255)
		lg.rectangle('line', v.x-v.w/2.15,v.y-20, v.maxHealth, 12)
		lg.print(tostring(math.floor(v.health)) .. ' / ' .. tostring(v.maxHealth), v.x-v.w/2.15, v.y-20)
	end
	self:animate()
end

return Enemy