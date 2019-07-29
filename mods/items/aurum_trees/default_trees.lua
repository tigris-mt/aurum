local S = minetest.get_translator()
local m = aurum.trees

m.register("aurum_trees:oak", {
	description = "Oak",
	texture_base = "aurum_trees_oak_%s.png",
})

m.register("aurum_trees:birch", {
	description = "Birch",
	texture_base = "aurum_trees_birch_%s.png",
})

-- "Pander"? I dunno, "jungle tree" sounded too generic.
m.register("aurum_trees:pander", {
	description = "Pander",
	texture_base = "aurum_trees_oak_%s.png^[colorize:#001100:160",
	decorations = {
		simple = false,
		wide = false,
		very_tall = true,
	},
})

m.register("aurum_trees:drywood", {
	description = "Drywood",
	texture_base = "aurum_trees_drywood_%s.png",
})
