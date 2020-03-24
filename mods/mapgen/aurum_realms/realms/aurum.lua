local S = minetest.get_translator()

screalms.register("aurum:aurum", {
	description = S("Aurum"),
	size = vector.new(16000, 1600, 16000),

	aurum_dungeon_loot = function(pos)
		return {
			count = math.random(1, 2),
			list = {
				{
					count = math.random(1, 2),
					preciousness = {0, 5},
					groups = {"spell", "enchantable", "food", "light"},
				},
			},
		}
	end,
})
