-- Barrens

aurum.biomes.register_all("aurum:aurum", {
	name = "aurum_barrens",
	_groups = {"barren"},
	heat_point = 30,
	humidity_point = 30,
	_variants = {
		base = aurum.biomes.v_base{
			node_top = "aurum_base:gravel",
			depth_top = 1,
			node_filler = "aurum_base:stone",
			depth_fillter = 1,
		},
		ocean = aurum.biomes.v_ocean{
			node_top = "aurum_base:stone",
			node_filler = "aurum_base:stone",
		},
		under = aurum.biomes.v_under{},
	},
})

-- Grassland

aurum.biomes.register_all("aurum:aurum", {
	name = "aurum_grassland",
	_groups = {"green"},
	heat_point = 40,
	humidity_point = 40,
	_variants = {
		base = aurum.biomes.v_base{
			node_top = "aurum_base:grass",
			depth_top = 1,
			node_filler = "aurum_base:dirt",
			depth_filler = 4,
		},
		ocean = aurum.biomes.v_ocean{},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:oak",
	biomes = {"aurum_grassland"},
	rarity = 0.01,
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:birch",
	biomes = {"aurum_grassland"},
	rarity = 0.01,
})

-- Forest

aurum.biomes.register_all("aurum:aurum", {
	name = "aurum_forest",
	_groups = table.icombine(aurum.biomes.biomes.aurum_grassland._groups, {"forest"}),
	heat_point = 50,
	humidity_point = 50,
	_variants = aurum.biomes.biomes.aurum_grassland._variants,
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:oak",
	biomes = {"aurum_forest"},
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:birch",
	biomes = {"aurum_forest"},
})
