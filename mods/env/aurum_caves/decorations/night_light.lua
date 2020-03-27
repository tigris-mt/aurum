aurum.features.register_decoration{
	place_on = {
		"group:ore_block",
	},
	rarity = 0.05,
	biomes = aurum.biomes.get_all_group("green", {"under"}),
	schematic = aurum.features.schematic(vector.new(1, 1, 1), {{{"aurum_flora:night_light"}}}),
	force_placement = true,
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

aurum.features.register_decoration{
	place_on = {
		"aurum_base:aether_flesh",
	},
	rarity = 0.01,
	biomes = aurum.biomes.get_all_group("aurum:aether"),
	schematic = aurum.features.schematic(vector.new(1, 1, 1), {{{"aurum_flora:night_light"}}}),
	force_placement = true,
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}
