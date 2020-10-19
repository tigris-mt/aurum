local S = aurum.get_translator()

minetest.register_craftitem("aurum_chef:reed_dough", {
	description = S"Tubal Reed Dough",
	inventory_image = "aurum_chef_reed_dough.png",
	groups = {dough = 1, cook_temp = 5},
})

minetest.register_craft{
	output = "aurum_chef:reed_dough 2",
	recipe = {
		{"aurum_flora:reed", "aurum_flora:reed"},
		{"aurum_flora:reed", "aurum_flora:reed"},
		{"aurum_flora:reed", "aurum_flora:reed"},
	},
}
