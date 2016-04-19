local Chest = {

}

function Chest:new (x, y, w, h, sprite, inventory)
	return {
		x = x,
		y = y,
		w = w,
		h = h,
		sprite = sprite,
		inventory = inventory
	}
end

function Chest:open ()
	for i = 0, #self.inventory do
		local randProb = math.random()
		if randProb < inventory[2] then
			table.insert(, inventory[1])
		end
	end
end