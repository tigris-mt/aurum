aurum.biomes.register("aurum:aurum", {
	name = "aurum_grassland",
	node_top = "aurum_base:grass",
	depth_top = 1,
	node_filler = "aurum_base:dirt",
	depth_filler = 3,
	heat_point = 40,
	humidity_point = 40,
})

minetest.clear_registered_biomes()

aurum.biomes.register("aurum:aurum", {
	name = "aurum_forest",
	node_top = "aurum_base:grass",
	depth_top = 1,
	node_filler = "aurum_base:dirt",
	depth_filler = 3,
	heat_point = 50,
	humidity_point = 50,
})
