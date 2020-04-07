local S = minetest.get_translator()

minetest.register_node("aurum_flare:flare", {
	description = S"Eternal Flare",
	_doc_items_longdesc = S"An eternal light source.",
	_doc_items_hidden = false,

	is_ground_content = false,
	groups = {dig_handle = 3, flammable = 1, attached_node = 1},
	sounds = aurum.sounds.wood(),

	walkable = false,

	paramtype = "light",
	paramtype2 = "wallmounted",

	inventory_image = "aurum_flare_inventory.png",
	wield_image = "aurum_flare_inventory.png",

	light_source = 12,
	tiles = {"aurum_flare_flare.png"},

	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.025, -0.5, -0.025, 0.025, -0.25, 0.025},
			{-0.05, -0.25, -0.05, 0.05, 0, 0.05},
		},
	},
})

minetest.register_craft{
	output = "aurum_flare:flare 4",
	recipe = {
		{"aurum_ore:mana_bean"},
		{"aurum_base:sticky_stick"},
	},
}

minetest.register_craft{
	type = "fuel",
	recipe = "aurum_flare:flare",
	burntime = 4,
}
