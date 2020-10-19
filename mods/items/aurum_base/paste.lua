local S = aurum.get_translator()

minetest.register_craftitem("aurum_base:paste", {
	description = S"Organic Paste",
	_doc_items_longdesc = S"Organic material ground into a thick blob of paste.",
	inventory_image = "aurum_base_paste.png",
	groups = {dye_source = 1, color_green = 1},
})

minetest.register_craft{
	output = "aurum_base:paste 3",
	recipe = {
		{"group:grass_soil"},
	},
}

minetest.register_craft{
	output = "aurum_base:paste 2",
	recipe = {
		{"group:leaves", "group:leaves", "group:leaves"},
	},
}

minetest.register_craft{
	output = "aurum_base:dirt",
	recipe = {
		{"aurum_base:paste", "aurum_base:gravel", "aurum_base:paste"},
	},
}
