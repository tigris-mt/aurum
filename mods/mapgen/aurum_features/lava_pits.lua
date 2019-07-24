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

local list = {}
for _,pos in ipairs(aurum.box.iterate(aurum.box.new(vector.new(1, 2, 1), vector.new(7, 6, 7)))) do
	table.insert(list, make(pos))
end

for _,d in ipairs(list) do
	local def = {
		deco_type = "schematic",
		place_on = {"group:soil", "aurum_base:gravel", "group:stone", "group:sand"},
		sidelen = 80,
		fill_ratio = 0.0001 / #list,
		biomes = aurum.biomes.get_all_group("aurum:aurum", {"base"}),
		schematic = d.schematic,
		rotation = "random",
		flags = {place_center_x = true, place_center_y = false, place_center_z = true, force_placement = true},
		place_offset_y = -math.floor(d.size.y / 2) - 2,
	}

	minetest.register_decoration(def)

	-- More common in the barrens.
	minetest.register_decoration(table.combine(def, {
		fill_ratio = 0.0004 / #list,
		biomes = table._and(
			aurum.biomes.get_all_group("aurum:aurum", {"base"}),
			aurum.biomes.get_all_group("barren", {"base"})
		),
	}))
end
