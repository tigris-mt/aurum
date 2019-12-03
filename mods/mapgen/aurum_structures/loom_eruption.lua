-- An eruption of regrets from the loom.
-- Occurs in all barrens.

local cache = {}

aurum.features.register_decoration{
	place_on = {"aurum_base:regret", "aurum_base:stone", "aurum_base:gravel"},
	rarity = 0.001,
	biomes = aurum.biomes.get_all_group("barren"),

	make_schematic = function(pos, random)
		local size = vector.new(random(1, 8), random(4, 18), random(1, 8))
		local hash = minetest.hash_node_position(size)
		local limit = vector.subtract(size, 1)

		pos.y = pos.y - math.floor(limit.y / 2)

		if not cache[hash] then
			local data = {}
			local area = aurum.box.voxelarea(aurum.box.new_add(vector.new(0, 0, 0), limit))

			for i in area:iterp(vector.new(0, 0, 0), limit) do
				data[i] = {name = "aurum_base:regret", prob = 64}
			end
			cache[hash] = data
		end

		return {
			size = size,
			data = cache[hash],
		}
	end,
}
