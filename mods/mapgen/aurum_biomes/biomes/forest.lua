aurum.biomes.register("aurum:aurum", {
	name = "aurum_forest",
	node_top = "aurum_base:grass",
	depth_top = 1,
	node_filler = "aurum_base:dirt",
	depth_filler = 3,
	heat_point = 50,
	humidity_point = 50,
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:oak",
	biomes = {"aurum_forest"},
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:birch",
	biomes = {"aurum_forest"},
})
