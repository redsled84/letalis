local Globals = require 'globals'
local tileSize = Globals.tileSize
local polyfill = {}

function polyfill.shallowCopy(t)
	local t2 = {}
	for k=1, #t do
		t2[k] = t[k]
	end
	return t2
end

function polyfill.setPosition(a1, a2, b1, b2)
	a1, b1 = a1+tileSize, b1+tileSize
	a2, b2 = a2-tileSize, b2-tileSize
	local a, b = 0, 0
	if a1 <= b2 and a2 >= b2 then
		a = a1
		b = b2
	end
	if a1 <= b1 and a2 >= b1 then
		a = a2
		b = b1
	end
	if a2 <= b2 and a1 >= b1 then
		a = a1
		b = a2
	end
	if a1 <= b1 and a2 >= b2 then
		a = b1
		b = b2
	end

	return a, b
end

function polyfill.approach (sVel, accel, goal)
	local dir = (sVel - goal > sVel) and -1 or (sVel - goal < sVel and 1 or (sVel > 0 and -1 or 1))
	if (dir > 0 and sVel + accel > goal) or (dir < 0 and sVel - accel < goal) then
		return goal
	end
	sVel = sVel + dir * accel
	return sVel
end

function polyfill.aabb(a, b)
	return a.x + a.w > b.x and
		a.x < b.x + b.w and
		a.y + a.h > b.y and
		a.y < b.y + b.h
end

function polyfill.dis(a, b)
	return math.abs(math.sqrt(((b.x+b.w/2)-(a.x+a.w/2))^2 + ((b.y+b.h/2)-(a.y+a.h/2))^2))
end

return polyfill