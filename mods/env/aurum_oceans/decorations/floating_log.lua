aurum.features.register_decoration{
	place_on = {"aurum_base:water_source"},
	rarity = 0.000025,
	biomes = aurum.biomes.get_all_group("aurum:aurum", {"base"}),
	schematic = aurum.features.schematic(vector.new(1, 5, 1), {
		{{"aurum_flora:good_mushroom"}},
		{{"aurum_trees:oak_trunk"}},
		{{"aurum_trees:oak_trunk"}},
		{{"aurum_trees:oak_trunk"}},
		{{"aurum_trees:oak_trunk"}},
	}),

	on_offset = function(c)
		return vector.subtract(c.pos, vector.new(0, c.random(2, 3), 0))
	end,
}

local ot = {name = "aurum_trees:oak_trunk", prob = 255, param2 = 12}

aurum.features.register_decoration{
	place_on = {"aurum_base:water_source"},
	rarity = 0.000025,
	biomes = aurum.biomes.get_all_group("aurum:aurum", {"base"}),
	schematic = aurum.features.schematic(vector.new(5, 2, 1), {
		{{"ignore", "aurum_flora:good_mushroom", "ignore", "ignore", "ignore"}},
		{{ot, ot, ot, ot, ot}},
	}),
}
