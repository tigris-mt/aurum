local S = minetest.get_translator()

minetest.register_craftitem("aurum_chef:flatbread", {
	description = S"Flatbread",
	inventory_image = "aurum_chef_flatbread.png",
	groups = {edible = 10},
	on_use = minetest.item_eat(10),
})

minetest.register_craft{
	type = "cooking",
	output = "aurum_chef:flatbread",
	recipe = "group:dough",
}
