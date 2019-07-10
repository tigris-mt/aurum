minetest.register_alias("mapgen_stone", "aurum_base:stone")

aurum.biomes.register("aurum_realms:aurum", {
	name = "aurum_barrens",
	node_top = "aurum_base:dirt",
	depth_top = 2,
	node_filler = "aurum_base:dirt",
	depth_filler = 4,
	y_min = -6,
	heat_point = 50,
	humidity_point = 50,
})

aurum.biomes.register("aurum_realms:aurum", {
	name = "aurum_barrens_underground",
	node_stone = "aurum_base:stone",
	y_max = 0,
	heat_point = 50,
	humidity_point = 50,
})
