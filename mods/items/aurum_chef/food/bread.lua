local S = aurum.get_translator()

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

minetest.register_craftitem("aurum_chef:meat_sandwich", {
	description = S"Meat Sandwich",
	inventory_image = "aurum_chef_meat_sandwich.png",
	groups = {edible = 25, edible_morale = 2},
	on_use = minetest.item_eat(25),
})

minetest.register_craft{
	output = "aurum_chef:meat_sandwich",
	recipe = {
		{"aurum_chef:flatbread"},
		{"aurum_chef:meat_patty"},
		{"aurum_chef:flatbread"},
	},
}
