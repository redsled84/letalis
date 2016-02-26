local collide = {}

function collide.check(o1, o2, f)
	if o1.x < o2.x+o2.width and
	o1.x + o1.width > o2.x and
	o1.y < o2.y+o2.height and
	o1.y + o1.height > o2.y then
		f()
	end
end

return collide