local S = minetest.get_translator()

minetest.register_craftitem("aurum_base:paste", {
	description = S"Organic Paste",
	_doc_items_longdesc = S"Organic material ground into a thick blob of paste.",
	inventory_image = "aurum_base_paste.png",
})

minetest.register_craft{
	output = "aurum_base:paste 3",
	recipe = {
		{"aurum_base:grass"},
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
