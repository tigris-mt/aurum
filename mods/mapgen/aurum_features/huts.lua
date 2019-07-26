local op = "aurum_trees:oak_planks"
local air = "air"

aurum.features.register_decoration{
	place_on = {"group:soil"},
	rarity = 0.00005,
	biomes = aurum.biomes.get_all_group("aurum:aurum", {"base"}),
	schematic = aurum.trees.schematic(vector.new(5, 4, 6), {
		{
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
			{air, air, air, air, air},
		},
		{
			{op, op, op, op, op},
			{op, air, air, air, op},
			{op, air, air, air, op},
			{op, air, air, air, op},
			{op, op, air, op, op},
			{air, air, air, air, air},
		},
		{
			{op, op, op, op, op},
			{op, "aurum_features:ph_1", air, "aurum_features:ph_1", op},
			{op, air, air, air, op},
			{op, "aurum_features:ph_1", air, "aurum_features:ph_1", op},
			{op, op, air, op, op},
			{air, air, air, air, air},
		},
		{
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
			{op, op, op, op, op},
		},
	}),

	on_generated = function(c)
		local ph = c:ph(1)

		minetest.set_node(ph[1], {name = "aurum_storage:box"})
		c:treasures(ph[1], "main", c:random(2, 4), {
			{
				count = math.random(1, 3),
				preciousness = {0, 2},
				groups = {"building_block"},
			},
		})
	end,
}
