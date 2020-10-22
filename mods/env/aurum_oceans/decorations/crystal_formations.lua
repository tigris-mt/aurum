minetest.register_node("aurum_oceans:crystal", {
	description = "Ocean Crystal",
	tiles = {"aurum_oceans_crystal.png"},
	paramtype = "light",
	light_source = 8,
	groups = {dig_pick = 3},
	sounds = aurum.sounds.crystal(),
})

-- More common, shorter.
minetest.register_decoration{
	name = "aurum_oceans:crystal",
	decoration = "aurum_oceans:crystal",
	deco_type = "simple",
	place_on = {"group:sand"},
	noise_params = {
		offset = 0,
		scale = 0.01,
		spread = vector.new(200, 200, 200),
		seed = 0x0CEA4C4151A1,
		octaves = 3,
		persist = 0.5,
	},
	y_max = -8,
	height_max = 4,
	flags = "force_placement",
	biomes = aurum.biomes.get_all_group("aurum:aurum", {"ocean"}),
	num_spawn_by = 1,
	spawn_by = {"group:water"},
}

-- Less common, taller.
minetest.register_decoration{
	name = "aurum_oceans:crystal",
	decoration = "aurum_oceans:crystal",
	deco_type = "simple",
	place_on = {"group:sand"},
	noise_params = {
		offset = -0.005,
		scale = 0.01,
		spread = vector.new(200, 200, 200),
		seed = 0x0CEA4C4151A1 + 1,
		octaves = 3,
		persist = 0.5,
	},
	y_max = -12,
	height_max = 12,
	flags = "force_placement",
	biomes = aurum.biomes.get_all_group("aurum:aurum", {"ocean"}),
	num_spawn_by = 1,
	spawn_by = {"group:water"},
}
