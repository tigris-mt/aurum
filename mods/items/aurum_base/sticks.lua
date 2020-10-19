local S = aurum.get_translator()

minetest.register_craftitem("aurum_base:stick", {
	description = S"Stick",
	_doc_items_hidden = false,
	inventory_image = "aurum_base_stick.png",
	groups = {stick = 1},
})

minetest.register_craft{
	output = "aurum_base:stick 4",
	recipe = {{"group:wood"}},
}

minetest.register_craftitem("aurum_base:sticky_stick", {
	description = S"Sticky Stick",
	inventory_image = "aurum_base_sticky_stick.png",
	groups = {stick = 1},
	_doc_items_longdesc = S"A stick covered in organic paste and stringy grass. It is particularly suited for affixing.",
	_doc_items_hidden = false,
})

minetest.register_craft{
	output = "aurum_base:sticky_stick",
	recipe = {
		{"aurum_base:paste"},
		{"aurum_base:stick"},
	},
}

minetest.register_craft{
	type = "fuel",
	recipe = "group:stick",
	burntime = 1,
}
