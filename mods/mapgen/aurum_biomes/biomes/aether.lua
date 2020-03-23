local d = {
	node_water = "air",
	node_cave_liquid = "air",
}

local function v_n(f, td)
	return function(def) return aurum.biomes[f](b.t.combine(d, td or {}, def)) end
end

local v_base = v_n("v_base", {
	y_min = 4,
	node_top = "aurum_base:aether_shell",
		depth_top = 1,
		node_filler = "aurum_base:aether_skin",
		depth_filler = 3,
	node_stone = "aurum_base:aether_flesh",
})

local v_under = v_n("v_under", {
	y_max = 4,
	node_stone = "aurum_base:aether_source",
})

aurum.biomes.register_all("aurum:aether", {
	name = "aether_living",
	heat_point = 30,
	humidity_point = 50,
	_variants = {
		base = v_base{},
		under = v_under{},
	},
})

aurum.biomes.register_all("aurum:aether", {
	name = "aether_white_crystal_forest",
	heat_point = 70,
	humidity_point = 30,
	_variants = {
		base = v_base{},
		under = v_under{},
	},
})

aurum.biomes.trees.register({
	name = "aurum_trees:white_crystal",
	biomes = {"aether_white_crystal_forest"},
	rarity = 1,
	custom_schematics = {
		["tree,24,16"] = 0.1,
		["tree,32,14"] = 0.1,
		["tree,16,22"] = 0.1,
		["cone,12"] = 0.1,
	},
})

aurum.biomes.trees.register({
	name = "aurum_trees:yellow_crystal",
	biomes = {"aether_white_crystal_forest"},
	rarity = 0.1,
})

aurum.biomes.register_all("aurum:aether", {
	name = "aether_yellow_crystal_forest",
	heat_point = 70,
	humidity_point = 70,
	_variants = {
		base = v_base{},
		under = v_under{},
	},
})

aurum.biomes.trees.register({
	name = "aurum_trees:yellow_crystal",
	biomes = {"aether_yellow_crystal_forest"},
	rarity = 0.4,
})
