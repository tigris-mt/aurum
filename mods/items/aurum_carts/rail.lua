local S = aurum.get_translator()

minetest.register_node("aurum_carts:rail", {
	description = S"Rail",
	drawtype = "raillike",
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	walkable = false,

	inventory_image = "aurum_carts_rail_line.png",

	tiles = {
		"aurum_carts_rail_line.png",
		"aurum_carts_rail_curve.png",
		"aurum_carts_rail_t.png",
		"aurum_carts_rail_cross.png",
	},

	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -7 / 16, 0.5},
	},

	groups = {
		dig_snap = 3,
		flammable = 1,
		attached_node = 1,
		connect_to_raillike = minetest.raillike_group("aurum_carts:rail"),
	},

	sounds = aurum.sounds.wood(),
})

minetest.register_craft{
	output = "aurum_carts:rail 12",
	recipe = {
		{"aurum_ore:iron_ingot", "group:stick", "aurum_ore:iron_ingot"},
		{"aurum_ore:iron_ingot", "", "aurum_ore:iron_ingot"},
		{"aurum_ore:iron_ingot", "group:stick", "aurum_ore:iron_ingot"},
	},
}
