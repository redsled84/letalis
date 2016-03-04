local collide = {}

function collide.checkRadius(o1, o2, f)
	if o1.x < o2.x+o2.width and
	o1.x + o1.width > o2.x and
	o1.y < o2.y+o2.height and
	o1.y + o1.height > o2.y then
		f(o1, o2)
	end
end

function collide.checkSides(o1, o2)
	local nx, ny
	 
	if o1.x + o1.width == o2.x and o1.y == o2.y then
		nx = -1
	elseif o1.x - o1.width == o2.x and o1.y == o2.y then
		nx = 1
	else
		nx = nil
	end
	if o1.y + o1.height == o2.x and o1.x == o2.x then
		ny = -1
	elseif o1.y - o1.height == o2.x and o1.x == o2.x then
		ny = 1
	else
		ny = nil
	end

	return nx, ny
end

return collide