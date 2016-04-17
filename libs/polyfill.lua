local Game = require 'game'
local tileSize = Game.tileSize
print(tileSize)
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

return polyfill