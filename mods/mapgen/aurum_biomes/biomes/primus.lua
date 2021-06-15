local function v_base(def)
	return aurum.biomes.v_base(b.t.combine({
		y_min = -50,
		node_water = "air",
		node_cave_liquid = "air",
	}, def))
end

aurum.biomes.register_all("aurum:primus", {
	name = "primus_jungle",
	_groups = {"green", "forest", "dark"},
	_color = b.color.convert"darkgreen",
	heat_point = 60,
	humidity_point = 60,
	_variants = {
		base = v_base{
			node_top = "aurum_base:dark_grass",
			depth_top = 1,
			node_filler = "aurum_base:dirt",
			depth_filler = 4,
		},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.register_all("aurum:primus", {
	name = "primus_swamp",
	_groups = {"green", "dark"},
	_color = b.color.convert"chocolate",
	heat_point = 20,
	humidity_point = 90,
	_variants = {
		base = v_base{
			node_top = "aurum_farming:fertilizer",
			depth_top = 1,
			node_filler = "aurum_farming:fertilizer",
			depth_filler = 4,
			node_water = "aurum_farming:fertilizer",
			node_cave_liquid = "aurum_farming:fertilizer",
		},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.trees.register(b.t.combine({
	name = "aurum_trees:pander",
	biomes = {"primus_jungle", "primus_swamp"},
	rarity = 15,
	terrain = {"group:soil", "group:fertilizer"},
}, {
	custom_schematics = aurum.trees.defaults.style.HUGE.pre,
	post_schematics = aurum.trees.defaults.style.HUGE.post,
}))

aurum.biomes.register_all("aurum:primus", {
	name = "primus_forest",
	_groups = {"green", "forest"},
	_color = b.color.convert"green",
	heat_point = 40,
	humidity_point = 40,
	_variants = {
		base = v_base{
			node_top = "aurum_base:grass",
			depth_top = 1,
			node_filler = "aurum_base:dirt",
			depth_filler = 4,
		},
		under = aurum.biomes.v_under{},
	},
})

local primus_forest_trees = {"aurum_trees:oak", "aurum_trees:birch"}

for _,tree in ipairs(primus_forest_trees) do
	aurum.biomes.trees.register({
		name = tree,
		biomes = {"primus_forest"},
		rarity = 10 / #primus_forest_trees,
		custom_schematics = {
			["tree,32,32"] = 0.01,
			["tree,48,16"] = 0.1,
			["tree,16,48"] = 0.001,
		},
		post_schematics = {
			["tree,72,6"] = 0.001,
		},
	})
end

aurum.biomes.trees.register{
	name = "aurum_trees:banana",
	biomes = {"primus_forest"},
	rarity = 1,
}

aurum.biomes.register_all("aurum:primus", {
	name = "primus_cold",
	_groups = {"green", "forest"},
	_color = b.color.convert"lime",
	heat_point = 10,
	humidity_point = 10,
	_variants = {
		base = v_base{
			node_top = "aurum_base:grass",
			depth_top = 1,
			node_filler = "aurum_base:dirt",
			depth_filler = 4,
		},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.trees.register(b.t.combine({
	name = "aurum_trees:pine",
	biomes = {"primus_cold"},
	rarity = 5,
}, {
	custom_schematics = aurum.trees.defaults.style.HUGE_CONE.pre,
	post_schematics = aurum.trees.defaults.style.HUGE_CONE.post,
}))

aurum.biomes.register_all("aurum:primus", {
	name = "primus_blue",
	_groups = {"green", "forest"},
	_color = b.color.convert"blue",
	heat_point = 10,
	humidity_point = 90,
	_variants = {
		base = v_base{
			node_top = "aurum_base:grass",
			depth_top = 1,
			node_filler = "aurum_base:dirt",
			depth_filler = 4,
		},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.trees.register(b.t.combine({
	name = "aurum_trees:azure_birch",
	biomes = {"primus_blue"},
	rarity = 5,
}, {
	post_schematics = aurum.trees.defaults.style.STILTS.post,
}))

aurum.biomes.register_all("aurum:primus", {
	name = "primus_dry",
	_groups = {"forest", "barren"},
	_color = b.color.convert"orange",
	heat_point = 95,
	humidity_point = 5,
	_variants = {
		base = v_base{
			node_top = "aurum_base:dirt",
			depth_top = 1,
			node_filler = "aurum_base:dirt",
			depth_filler = 4,
		},
		under = aurum.biomes.v_under{},
	},
})

aurum.biomes.trees.register(b.t.combine({
	name = "aurum_trees:drywood",
	biomes = {"primus_dry"},
	rarity = 5,
}, {
	custom_schematics = aurum.trees.defaults.style.TALL.pre,
	post_schematics = aurum.trees.defaults.style.TALL.post,
}))
