local function make(size)
	local function rep(x, n)
		local ret = {}
		for i=1,n do
			ret[i] = x
		end
		return ret
	end

	local air_size = math.floor(size.y / 2)
	local bowl_size = math.ceil(size.y / 2)

	local nodes = {}

	for i=1,air_size do
		table.insert(nodes, rep(rep({name = "air", prob = 64}, size.x), size.z))
	end

	for i=bowl_size,1,-1 do
		local slice = rep(rep("aurum_base:lava_source", size.x), size.z)
		table.insert(nodes, slice)
	end

	return {schematic = aurum.trees.schematic(size, nodes), size = size}
end

local list = {
	make(vector.new(2, 2, 2)),
	make(vector.new(3, 4, 3)),
	make(vector.new(2, 3, 4)),
	make(vector.new(4, 4, 3)),
	make(vector.new(5, 5, 6)),
}

for _,d in ipairs(list) do
	local def = {
		deco_type = "schematic",
		place_on = {"group:soil", "aurum_base:gravel", "group:stone"},
		sidelen = 80,
		fill_ratio = 0.0005 / #list,
		biomes = {"aurum_grassland"},
		schematic = d.schematic,
		rotation = "random",
		flags = {place_center_x = true, place_center_y = false, place_center_z = true, force_placement = true},
		place_offset_y = -math.floor(d.size.y / 2) - 2,
	}

	minetest.register_decoration(def)
	minetest.register_decoration(table.combine(def, {
		fill_ratio = 0.001 / #list,
		biomes = {"aurum_barrens"},
	}))
end
