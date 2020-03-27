-- A deep pit formerly used for mining the loom.
-- Some tools/materials are left behind.

local make = b.cache.simple(function(size)
	local limit = vector.subtract(size, 1)
	local data = {}
	local area = VoxelArea:new({MinEdge=vector.new(0, 0, 0), MaxEdge=limit})
	for i in area:iterp(vector.new(0, 0, 0), limit) do
		data[i] = {name = "air"}
	end
	for x=0,limit.x do
		for z=0,limit.z do
			for y=0,limit.y do
				if x == 0 or x == limit.x or z == 0 or z == limit.z or y == 0 then
					data[area:index(x, y, z)] = {name = "aurum_base:regret_brick"}
				elseif y == 1 and (x == 1 or x == (limit.x - 1) or z == 1 or z == (limit.z - 1)) then
					data[area:index(x, y, z)] = {name = "aurum_features:ph_1"}
				end
			end
		end
	end
	return {
		size = size,
		data = data,
	}
end, function(size) return minetest.hash_node_position(size) end)

aurum.features.register_decoration{
	place_on = {
		"aurum_base:regret",
	},
	rarity = 0.001,
	biomes = aurum.biomes.get_all_group("aurum:loom"),

	on_offset = function(c)
		c.s.size = vector.new(c.random(4, 8), c.random(16, 120), c.random(4, 8))
		return vector.subtract(c.pos, vector.new(0, c.s.size.y + 1, 0))
	end,

	make_schematic = function(c)
		return make(c.s.size)
	end,

	on_generated = function(c)
		if #c:ph(1) > 0 then
			minetest.set_node(c:ph(1)[1], {name = "aurum_storage:shell_box"})
			c:treasures(c:ph(1)[1], "main", c:random(1, 3), {
				{
					count = 1,
					preciousness = {0, 8},
					groups = {"minetool", "food", "raw_food", "worker"},
				},
			})
		end
	end,
}
