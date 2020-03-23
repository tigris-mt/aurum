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
			depth_filler = 1,
		},
		ocean = aurum.biomes.v_ocean{
			node_top = "aurum_base:stone",
			node_filler = "aurum_base:stone",
		},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.trees.register({
	name = "aurum_trees:drywood",
	biomes = {"aurum_barrens"},
	rarity = 0.1,
	schematics = {},
	custom_schematics = {
		["log,32,4,,-1"] = 0.25,
	},
	post_schematics = {
		["tree,64,8"] = 1,
		["tree,48,16"] = 1,
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

aurum.biomes.trees.register({
	name = "aurum_trees:oak",
	biomes = {"aurum_grassland"},
	rarity = 0.01,
})

aurum.biomes.trees.register({
	name = "aurum_trees:birch",
	biomes = {"aurum_grassland"},
	rarity = 0.01,
})

-- Forest
aurum.biomes.register_all("aurum:aurum", {
	name = "aurum_forest",
	_groups = b.t.icombine(aurum.biomes.biomes.aurum_grassland._groups, {"forest"}),
	heat_point = 50,
	humidity_point = 50,
	_variants = aurum.biomes.biomes.aurum_grassland._variants,
})

aurum.biomes.trees.register({
	name = "aurum_trees:oak",
	biomes = {"aurum_forest"},
})

aurum.biomes.trees.register({
	name = "aurum_trees:birch",
	biomes = {"aurum_forest"},
})

-- Jungle
aurum.biomes.register_all("aurum:aurum", {
	name = "aurum_jungle",
	_groups = b.t.icombine(aurum.biomes.biomes.aurum_forest._groups, {"dark"}),
	heat_point = 80,
	humidity_point = 80,
	_variants = {
		base = aurum.biomes.v_base{
			node_top = "aurum_base:dark_grass",
			depth_top = 1,
			node_filler = "aurum_base:dirt",
			depth_filler = 4,
		},
		ocean = aurum.biomes.v_ocean{},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.trees.register({
	name = "aurum_trees:pander",
	biomes = {"aurum_jungle"},
	rarity = 20,
})

-- Desert
aurum.biomes.register_all("aurum:aurum", {
	name = "aurum_desert",
	_groups = {"desert"},
	heat_point = 80,
	humidity_point = 10,
	_variants = {
		base = aurum.biomes.v_base{
			node_top = "aurum_base:sand",
			depth_top = 8,
		},
		ocean = aurum.biomes.v_ocean{},
		under = aurum.biomes.v_under{},
	},
})

-- Frozen Forest
aurum.biomes.register_all("aurum:aurum", {
	name = "aurum_frozen_forest",
	_groups = {"frozen", "forest"},
	heat_point = 25,
	humidity_point = 70,
	_variants = {
		base = aurum.biomes.v_base{
			node_top = "aurum_base:snow",
			depth_top = 1,
			node_filler = "aurum_base:dirt",
			depth_filler = 4,
			node_water_top = "aurum_base:ice",
			depth_water_top = 2,
			node_river_water = "aurum_base:ice",
		},
		ocean = aurum.biomes.v_ocean{
			node_river_water = "aurum_base:ice",
			node_water_top = "aurum_base:ice",
			depth_water_top = 2,
		},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.trees.register({
	name = "aurum_trees:pine",
	biomes = {"aurum_frozen_forest"},
})

-- Frozen
local frozen = {
	node_top = "aurum_base:snow",
	depth_top = 1,
	node_filler = "aurum_base:ground_ice",
	node_water_top = "aurum_base:ice",
	depth_water_top = 10,
	node_river_water = "aurum_base:ice",
	node_cave_liquid = "aurum_base:ice",
	node_stone = "aurum_base:ground_ice",
}

aurum.biomes.register_all("aurum:aurum", {
	name = "aurum_frozen",
	_groups = {"frozen"},
	heat_point = 0,
	humidity_point = 70,
	_variants = {
		base = b.t.combine(frozen, aurum.biomes.v_base{
			node_dungeon = "aurum_base:snow",
			node_dungeon_alt = "aurum_base:snow",
			node_dungeon_stair = "aurum_base:snow",
		}),
		ocean = b.t.combine(frozen, aurum.biomes.v_ocean{}),
		under = aurum.biomes.v_under{},
	},
})
