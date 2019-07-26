local op = "aurum_trees:oak_planks"
local air = "air"

aurum.features.register_decoration{
	place_on = {"group:soil"},
	rarity = 0.000005,
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
		local inv = minetest.get_meta(ph[1]):get_inventory()

		for _,stack in ipairs(treasurer.select_random_treasures(10, 0, 2, "building_block")) do
			inv:add_item("main", stack)
		end

		inv:set_list("main", table.shuffled(inv:get_list("main")))
	end,
}
