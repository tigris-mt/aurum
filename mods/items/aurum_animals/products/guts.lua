local S = aurum.get_translator()

minetest.register_craftitem("aurum_animals:bone", {
	description = S"Bone",
	inventory_image = "aurum_animals_bone.png",
	groups = {bone = 1},
})

minetest.register_craftitem("aurum_animals:raw_meat", {
	description = S"Raw Meat",
	_doc_items_longdesc = S"A chunk of raw meat. It probably wouldn't be a good idea to eat this.",
	inventory_image = "aurum_animals_raw_meat.png",
	groups = {raw_meat = 1},
	on_use = function(itemstack, user)
		if user and user:is_player() then
			aurum.effects.add(user, "aurum_effects:poison", 1, 10)
			itemstack:take_item()
			return itemstack
		end
	end,
})

minetest.register_craftitem("aurum_animals:cooked_meat", {
	description = S"Cooked Meat",
	inventory_image = "aurum_animals_cooked_meat.png",
	on_use = minetest.item_eat(25),
	groups = {edible = 25},
})

minetest.register_craft{
	type = "cooking",
	output = "aurum_animals:cooked_meat",
	recipe = "aurum_animals:raw_meat",
	cooktime = 10,
}
