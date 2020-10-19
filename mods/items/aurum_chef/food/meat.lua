local S = aurum.get_translator()

minetest.register_craftitem("aurum_chef:meat_patty", {
	description = S"Meat Patty",
	inventory_image = "aurum_chef_meat_patty.png",
	on_use = minetest.item_eat(10),
	groups = {edible = 10},
})

minetest.register_craft{
	output = "aurum_chef:meat_patty 2",
	recipe = {
		{"aurum_chef:salt"},
		{"aurum_animals:cooked_meat"},
	},
}
