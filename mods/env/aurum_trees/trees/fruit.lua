local S = aurum.get_translator()

aurum.trees.register("aurum_trees:apple", {
	description = "Apple",
	texture_base = "aurum_trees_oak_%s.png^[colorize:#666600:160",

	decorations = {
		["tree,10,4,,,,,aurum_trees:apple"] = 1,
		["tree,12,5,,,,,aurum_trees:apple"] = 1,
		["tree,14,4,,,,,aurum_trees:apple"] = 1,
		["l_flowing_fruit,aurum_trees:apple"] = 2,
	},
})

minetest.register_node("aurum_trees:apple", {
	description = S"Apple",
	drawtype = "plantlike",
	tiles = {"aurum_trees_apple.png"},
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
	on_use = minetest.item_eat(10),
	groups = {dig_immediate = 2, flammable = 1, dig_snap = 3, edible = 10},
})

aurum.trees.leafdecay.register{
	trunk = "aurum_trees:apple_trunk",
	leaves = "aurum_trees:apple",
	leafdistance = 4,
	drop_all = true,
}

minetest.register_craft{
	output = "aurum_trees:apple_sapling",
	recipe = {
		{"aurum_trees:apple"},
		{"group:fertilizer"},
		{"group:soil"},
	},
}

aurum.trees.register("aurum_trees:banana", {
	description = "Banana",
	texture_base = "aurum_trees_oak_%s.png^[colorize:#009955:160",

	decorations = {
		["tree,15,5,,,,,aurum_trees:banana"] = 1,
		["tree,18,7,,,,,aurum_trees:banana"] = 1,
		["tree,20,6,,,,,aurum_trees:banana"] = 1,
	},
})

minetest.register_node("aurum_trees:banana", {
	description = S"Banana",
	drawtype = "torchlike",
	tiles = {"aurum_trees_banana.png"},
	inventory_image = "aurum_trees_banana.png",
	wield_image = "aurum_trees_banana.png",
	selection_box = {
		type = "fixed",
		fixed = {
			-0.3, -0.3, -0.3, 0.3, 0.5, 0.3,
		},
	},

	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,

	sounds = aurum.sounds.leaves(),
	on_use = minetest.item_eat(10),
	groups = {dig_immediate = 2, flammable = 1, dig_snap = 3, dye_source = 1, color_brown = 1, edible = 10},
})

aurum.trees.leafdecay.register{
	trunk = "aurum_trees:banana_trunk",
	leaves = "aurum_trees:banana",
	leafdistance = 4,
	drop_all = true,
}

minetest.register_craft{
	output = "aurum_trees:banana_sapling",
	recipe = {
		{"aurum_trees:banana"},
		{"group:fertilizer"},
		{"group:soil"},
	},
}
