local S = minetest.get_translator()

aurum.trees.register("aurum_trees:aether_flesh", {
	description = "Aether Flesh",
	terrain = {"aurum_base:aether_shell", "aurum_base:aether_skin"},
	terrain_desc = S"aether shell and skin",

	leafdistance = 8,
	leafdecay = false,

	trunk = "aurum_base:aether_skin",
	leaves = "aurum_base:aether_flesh",
	sapling = "",
	planks = "",

	decorations = {
		simple = 0,
		wide = 0,
		very_tall = 1,
		huge = 0.25,
		giant = 0.1,
		["tree,48,16"] = 0.01,
	},
})
