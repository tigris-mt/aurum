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

	make_schematic = function(pos, random)
		local size = vector.new(random(1, 8), random(4, 18), random(1, 8))
		pos.y = pos.y - math.floor((size.y - 1) / 2)
		return make(size)
	end,
}
