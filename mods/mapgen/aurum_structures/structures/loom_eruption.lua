-- An eruption of regrets from the loom.
-- Occurs in all barrens.

local make = b.cache.simple(function(size)
	local limit = vector.subtract(size, 1)

	local data = {}
	local area = b.box.voxelarea(b.box.new_add(vector.new(0, 0, 0), limit))

	for i in area:iterp(vector.new(0, 0, 0), limit) do
		data[i] = {name = "aurum_base:regret", prob = 64}
	end

	return {
		size = size,
		data = data,
	}
end, function(size) return minetest.hash_node_position(size) end)

aurum.features.register_decoration{
	place_on = {"aurum_base:regret", "aurum_base:stone", "aurum_base:gravel"},
	rarity = 0.001,
	biomes = aurum.biomes.get_all_group("barren"),

	on_offset = function(c)
		c.eruption_size = vector.new(c.random(1, 8), c.random(4, 18), c.random(1, 8))
		return vector.apply(vector.subtract(c.pos, vector.new(0, (c.eruption_size.y - 1) / 2, 0)), math.floor)
	end,

	make_schematic = function(c)
		return make(c.eruption_size)
	end,
}
