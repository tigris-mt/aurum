local S = minetest.get_translator()

minetest.register_node("aurum_base:stone_brick", {
	description = S"Stone Brick",
	tiles = {"aurum_base_stone_brick.png"},
	sounds = aurum.sounds.stone(),
	groups = {dig_pick = 2},
})

minetest.register_craft{
	type = "cooking",
	recipe = "aurum_base:stone",
	output = "aurum_base:stone_brick",
}

minetest.register_node("aurum_base:regret_brick", {
	description = S"Regret Brick",
	_doc_items_longdesc = S"Some million years ago, a titan of antiquity saw the eternal regret of the Loom and said, 'Ah, but what if I made bricks?'",
	tiles = {"aurum_base_stone_brick.png^[colorize:#440000:127"},
	sounds = aurum.sounds.stone(),
	groups = {dig_pick = 2, level = 2},
})

minetest.register_craft{
	type = "cooking",
	recipe = "aurum_base:regret",
	output = "aurum_base:regret_brick",
}
