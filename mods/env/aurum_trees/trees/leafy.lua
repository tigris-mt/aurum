local S = aurum.get_translator()

aurum.trees.register("aurum_trees:oak", {
	description = "Oak",
	texture_base = "aurum_trees_oak_%s.png",
})

aurum.trees.register("aurum_trees:birch", {
	description = "Birch",
	texture_base = "aurum_trees_birch_%s.png",
})

-- "Pander"? I dunno, "jungle tree" sounded too generic.
aurum.trees.register("aurum_trees:pander", {
	description = "Pander",
	texture_base = "aurum_trees_oak_%s.png^[colorize:#001100:140",
	decorations = aurum.trees.defaults.JUNGLE,
})

aurum.trees.register("aurum_trees:azure_birch", {
	description = "Azure Birch",
	texture_base = "aurum_trees_birch_%s.png^[colorize:#0000ff:64",
	decorations = aurum.trees.defaults.STILTS,
})

aurum.trees.register("aurum_trees:drywood", {
	description = "Drywood",
	texture_base = "aurum_trees_drywood_%s.png",
	terrain = {"group:soil", "aurum_base:gravel"},
	terrain_desc = S"any dirt, soil, or gravel",
	decorations = b.t.combine(aurum.trees.defaults.ALL, {
		very_tall = 0.5,
		huge = 0.15,
	}),
})

aurum.trees.register("aurum_trees:pine", {
	description = "Pine",
	texture_base = "aurum_trees_pine_%s.png",
	terrain = {"group:soil", "group:snow"},
	terrain_desc = S"any dirt, soil, or snow",
	-- Pine trees only use cone schematics.
	decorations = b.t.combine({
		["cone,2,,,aurum_trees:pine_nuts"] = 0.1,
		["cone,3,,,aurum_trees:pine_nuts"] = 1,
		["cone,4,,,aurum_trees:pine_nuts"] = 1,
		["cone,5,,aurum_trees:pine_nuts"] = 1,
		["cone,8,,,aurum_trees:pine_nuts"] = 0.25,
		["cone,9,0.5,3,aurum_trees:pine_nuts"] = 0.15,
		["cone,12,,,aurum_trees:pine_nuts"] = 0.1,
		["cone,14,,,aurum_trees:pine_nuts"] = 0.05,
		["cone,14,1.5,,aurum_trees:pine_nuts"] = 0.05,
	}, aurum.trees.defaults.LOG),
})

minetest.register_node("aurum_trees:pine_nuts", {
	description = S"Pine Nuts",
	drawtype = "plantlike",
	tiles = {"aurum_trees_pine_nuts.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			-0.3, -0.5, -0.3, 0.3, 0.5, 0.3,
		},
	},

	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,

	sounds = aurum.sounds.leaves(),
	on_use = minetest.item_eat(3),
	groups = {dig_immediate = 2, flammable = 1, dig_snap = 3, edible = 3},
})

aurum.trees.leafdecay.register{
	trunk = "aurum_trees:pine_trunk",
	leaves = "aurum_trees:pine_nuts",
	leafdistance = 4,
	drop_all = true,
}

minetest.register_craft{
	output = "aurum_trees:pine_sapling",
	recipe = {
		{"aurum_trees:pine_nuts"},
		{"group:fertilizer"},
		{"group:soil"},
	},
}
