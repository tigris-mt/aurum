b.dodir("decorations")

-- Gravel sheets within stone.
minetest.register_ore{
	biomes = aurum.biomes.get_all_group("all"),
	ore_type = "sheet",
	ore = "aurum_base:gravel",
	wherein = "aurum_base:stone",
	clust_scarcity = 1,
	clust_num_ores = 1,
	clust_size = 4,
	noise_params = {
		offset = 0,
		scale = 1,
		spread = {x = 150, y = 150, z = 150},
		seed = 0x64A4E1,
		octaves = 3,
		persist = 0.5,
	},
}

-- Dirt sheets within stone.
minetest.register_ore{
	biomes = aurum.biomes.get_all_group("all"),
	ore_type = "sheet",
	ore = "aurum_base:dirt",
	wherein = "aurum_base:stone",
	clust_scarcity = 1,
	clust_num_ores = 1,
	clust_size = 4,
	noise_params = {
		offset = 0,
		scale = 1,
		spread = {x = 150, y = 150, z = 150},
		seed = 0xD141,
		octaves = 3,
		persist = 0.5,
	},
}
