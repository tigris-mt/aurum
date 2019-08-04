local function v_ocean(def)
	return table.combine({
		y_max = 0,
		y_min = -100,
	}, def)
end

aurum.biomes.register_all("aurum:loom", {
	name = "loom_barrens",
	_groups = {"barren"},
	heat_point = 80,
	humidity_point = 20,
	_variants = {
		base = aurum.biomes.v_base{},
		ocean = v_ocean{},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.register_all("aurum:loom", {
	name = "loom_crystal_forest",
	_groups = {},
	heat_point = 60,
	humidity_point = 40,
	_variants = {
		base = aurum.biomes.v_base{},
		ocean = v_ocean{},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:red_crystal",
	biomes = {"loom_crystal_forest"},
	rarity = 8,
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:yellow_crystal",
	biomes = {"loom_crystal_forest"},
	rarity = 4,
})

aurum.biomes.register_all("aurum:loom", {
	name = "loom_forest",
	_groups = {"forest"},
	heat_point = 50,
	humidity_point = 50,
	_variants = {
		base = aurum.biomes.v_base{
			node_top = "aurum_base:dirt",
			depth_top = 2,
		},
		ocean = v_ocean{},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:drywood",
	biomes = {"loom_forest"},
})

minetest.register_decoration{
	name = "loom_fire",
	decoration = "fire:permanent_flame",
	deco_type = "simple",
	place_on = {"aurum_base:regret"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.05,
		spread = vector.new(200, 200, 200),
		seed = 99,
		octaves = 3,
		persist = 0.5,
	},
	biomes = aurum.biomes.get_all_group("aurum:loom"),
}
