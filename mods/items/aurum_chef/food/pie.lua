local S = aurum.get_translator()

minetest.register_craftitem("aurum_chef:makeshift_pumpkin_pie", {
	description = S"Makeshift Pumpkin Pie",
	inventory_image = "aurum_chef_makeshift_pumpkin_pie.png",
	groups = {edible = 15, edible_morale = 1},
	on_use = minetest.item_eat(15),
})

minetest.register_craft{
	output = "aurum_chef:makeshift_pumpkin_pie",
	recipe = {
		{"aurum_farming:pumpkin_chunk"},
		{"aurum_chef:flatbread"},
	},
}
