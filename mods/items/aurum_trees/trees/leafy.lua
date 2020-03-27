local S = minetest.get_translator()

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
	texture_base = "aurum_trees_oak_%s.png^[colorize:#001100:160",
	decorations = aurum.trees.defaults.JUNGLE,
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
		["cone,2"] = 0.1,
		["cone,3"] = 1,
		["cone,4"] = 1,
		["cone,5"] = 1,
		["cone,8"] = 0.25,
		["cone,9,0.5,3"] = 0.15,
		["cone,12"] = 0.1,
		["cone,14"] = 0.05,
		["cone,14,1.5"] = 0.05,
	}, aurum.trees.defaults.LOG),
})
