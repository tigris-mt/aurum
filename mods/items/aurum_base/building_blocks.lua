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
