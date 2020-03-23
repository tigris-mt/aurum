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
	name = "aether_crystal_forest",
	heat_point = 70,
	humidity_point = 50,
	_variants = {
		base = v_base{},
		under = v_under{},
	},
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:white_crystal",
	biomes = {"aether_crystal_forest"},
	rarity = 4,
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:yellow_crystal",
	biomes = {"aether_crystal_forest"},
	rarity = 4,
})
