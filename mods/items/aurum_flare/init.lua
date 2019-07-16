local S = minetest.get_translator()

minetest.register_node("aurum_flare:flare", {
	description = S"Eternal Flare",
	_doc_items_longdesc = S"An eternal light source.",
	groups = {dig_handle = 3, flammable = 1, attached_node = 1},
	sounds = aurum.sounds.wood(),

	walkable = false,

	paramtype = "light",
	paramtype2 = "wallmounted",

	light_source = 12,
	tiles = {{
		image = "aurum_flare_flare.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1,
		},
	}},

	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.025, -0.5, -0.025, 0.025, 0, 0.025},
			{-0.1, 0, -0.1, 0.1, 0.5, 0.1},
		},
	},
})

minetest.register_craft{
	output = "aurum_flare:flare 2",
	recipe = {
		{"aurum_ore:mana_bean"},
		{"aurum_base:sticky_stick"},
	},
}
