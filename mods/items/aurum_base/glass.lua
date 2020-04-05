local S = minetest.get_translator()

aurum.dye.register_node("aurum_base:glass", {
	description = S"Glass",
	tiles = {
		"aurum_base_glass.png",
		"aurum_base_glass_detail.png",
	},
	groups = {dig_dig = 3, dig_handle = 2, glass = 1},
	sounds = aurum.sounds.glass(),
	paramtype = "light",
	drawtype = "glasslike_framed_optional",
	sunlight_propagates = true,
	use_texture_alpha = true,
}, "group:glass")

minetest.register_craft{
	type = "cooking",
	output = "aurum_base:glass_white",
	recipe = "aurum_base:sand",
}
