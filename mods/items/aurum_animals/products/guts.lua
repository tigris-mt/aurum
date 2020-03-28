local S = minetest.get_translator()

minetest.register_craftitem("aurum_animals:bone", {
	description = S"Bone",
	inventory_image = "aurum_animals_bone.png",
	groups = {bone = 1},
})

minetest.register_craftitem("aurum_animals:raw_meat", {
	description = S"Raw Meat",
	inventory_image = "aurum_animals_raw_meat.png",
	groups = {raw_meat = 1},
})

minetest.register_craftitem("aurum_animals:cooked_meat", {
	description = S"Cooked Meat",
	inventory_image = "aurum_animals_cooked_meat.png",
	on_use = minetest.item_eat(8),
	groups = {edible = 8},
})

minetest.register_craft{
	type = "cooking",
	output = "aurum_animals:cooked_meat",
	recipe = "aurum_animals:raw_meat",
}
