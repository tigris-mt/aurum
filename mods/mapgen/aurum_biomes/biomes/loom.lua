local function v_base(def)
	return aurum.biomes.v_base(b.t.combine({
		y_min = -100,
		node_water = "air",
		node_cave_liquid = "air",
	}, def))
end

aurum.biomes.register_all("aurum:loom", {
	name = "loom_lava",
	heat_point = 90,
	humidity_point = 10,
	_color = b.color.convert"red",
	_variants = {
		base = v_base{
			node_top = "aurum_base:lava_source",
			depth_top = 5,
		},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.register_all("aurum:loom", {
	name = "loom_barrens",
	_groups = {"barren"},
	_color = b.color.convert"grey",
	heat_point = 70,
	humidity_point = 30,
	_variants = {
		base = v_base{},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.register_all("aurum:loom", {
	name = "loom_hollow",
	_groups = {"barren"},
	_color = b.color.convert"darkgrey",
	heat_point = 10,
	humidity_point = 20,
	_variants = {
		base = v_base{
			node_top = "aurum_base:regret",
			depth_top = 2,
			node_filler = "air",
			depth_filler = 10,
		},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.register_all("aurum:loom", {
	name = "loom_crystal_forest",
	_color = b.color.convert"yellow",
	_groups = {},
	heat_point = 50,
	humidity_point = 60,
	_variants = {
		base = v_base{},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.trees.register({
	name = "aurum_trees:red_crystal",
	biomes = {"loom_crystal_forest"},
	rarity = 4,
})

aurum.biomes.trees.register({
	name = "aurum_trees:yellow_crystal",
	biomes = {"loom_crystal_forest"},
	rarity = 2,
})

aurum.biomes.register_all("aurum:loom", {
	name = "loom_forest",
	_groups = {"forest"},
	_color = b.color.convert"orange",
	heat_point = 40,
	humidity_point = 50,
	_variants = {
		base = v_base{
			node_top = "aurum_base:dirt",
			depth_top = 2,
		},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.trees.register({
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
