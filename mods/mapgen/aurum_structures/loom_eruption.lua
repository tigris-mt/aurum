-- An eruption of regrets from the loom.
-- Occurs in all barrens.

aurum.features.register_decoration{
	place_on = {"aurum_base:regret", "aurum_base:stone", "aurum_base:gravel"},
	rarity = 0.001,
	biomes = aurum.biomes.get_all_group("barren"),

	make_schematic = function(pos, random)
		local size = vector.new(random(1, 4), random(4, 18), random(1, 4))
		local limit = vector.subtract(size, 1)

		pos.y = pos.y - math.floor(limit.y / 2)

		local area = aurum.box.voxelarea(aurum.box.new_add(vector.new(0, 0, 0), limit))
		local data = {}

		for i in area:iterp(vector.new(0, 0, 0), limit) do
			data[i] = {name = "aurum_base:regret", prob = 64}
		end

		return {
			size = size,
			data = data,
		}
	end,
}
