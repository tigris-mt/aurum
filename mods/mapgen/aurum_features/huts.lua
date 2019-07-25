local op = "aurum_trees:oak_planks"
local air = "air"

aurum.features.register_decoration({
	deco_type = "schematic",
	place_on = {"group:soil"},
	sidelen = 80,
	fill_ratio = 0.001,
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
			{op, air, air, air, op},
			{op, air, air, air, op},
			{op, air, air, air, op},
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
	rotation = "random",
	flags = {force_placement = true},
}, {
})
