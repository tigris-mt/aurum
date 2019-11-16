local function v_base(def)
	return aurum.biomes.v_base(b.t.combine({
		-- There is no ocean in Primus Hortum.
		y_min = -100,
		node_water = "air",
	}, def))
end

aurum.biomes.register_all("aurum:primus", {
	name = "primus_jungle",
	_groups = {"green", "forest", "dark"},
	heat_point = 50,
	humidity_point = 50,
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

aurum.biomes.register_tree_decoration({
	name = "aurum_trees:pander",
	biomes = {"primus_jungle"},
	rarity = 40,
	custom_schematics = {
		["tree,32,32"] = 0.01,
		["tree,48,16"] = 0.1,
		["tree,16,48"] = 0.001,
		["cone,16"] = 0.01,
		["cone,14"] = 0.01,
		["cone,24"] = 0.001,
	},
	post_schematics = {
		["log,64,8,,-2"] = 0.0025,
		["tree,64,8"] = 0.025,
		["tree,72,24"] = 0.01,
		["tree,144,48"] = 0.001,
		["log,144,16,,-4"] = 0.001,
	},
})

aurum.biomes.register_all("aurum:primus", {
	name = "primus_forest",
	_groups = {"green", "forest"},
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
	aurum.biomes.register_tree_decoration({
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
