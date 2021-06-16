local S = aurum.get_translator()

aurum.dye.register_node("aurum_base:glass", {
	description = S"Glass",
	tiles = {
		"aurum_base_glass.png",
		"aurum_base_glass_detail.png",
	},
	groups = {dig_dig = 3, dig_handle = 2, glass = 1, shapable = 1},
	sounds = aurum.sounds.glass(),
	paramtype = "light",
	drawtype = "glasslike_framed_optional",
	sunlight_propagates = true,
	use_texture_alpha = "blend",
}, "group:glass")

minetest.register_craft{
	type = "cooking",
	output = "aurum_base:glass_white",
	recipe = "aurum_base:sand",
}

aurum.dye.register_node("aurum_base:glowing_glass", {
	description = S"Glowing Glass",
	tiles = {
		"aurum_base_glass.png",
		"aurum_base_glass_detail.png",
	},
	groups = {dig_dig = 3, dig_handle = 2, glowing_glass = 1, shapable = 1},
	sounds = aurum.sounds.glass(),
	paramtype = "light",
	drawtype = "glasslike_framed_optional",
	sunlight_propagates = true,
	use_texture_alpha = "blend",
	light_source = 12,
}, "group:glowing_glass")
