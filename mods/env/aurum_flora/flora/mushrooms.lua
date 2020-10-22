local S = aurum.get_translator()

local box = {
	type = "fixed",
	fixed = {
		-2 / 16, -8 / 16, -2 / 16,
		2 / 16, 3 / 16, 2 / 16,
	},
}

aurum.flora.register("aurum_flora:evil_mushroom", {
	description = S"Evil Mushroom",
	tiles = {"aurum_flora_evil_mushroom.png"},
	selection_box = box,
	on_use = function(itemstack, user)
		if user and user:is_player() then
			aurum.effects.add(user, "aurum_effects:poison", 1, 10)
			itemstack:take_item()
			return itemstack
		end
	end,
	_flora_light = 0,
})

aurum.flora.register("aurum_flora:good_mushroom", {
	description = S"Good Mushroom",
	tiles = {"aurum_flora_good_mushroom.png"},
	selection_box = box,
	groups = {edible = 5},
	on_use = minetest.item_eat(5),
	_flora_light = 0,
})

aurum.features.register_decoration{
	place_on = {
		"group:soil",
	},
	rarity = 0.05,
	biomes = aurum.biomes.get_all_group("all", {"under"}),
	schematic = aurum.features.schematic(vector.new(1, 1, 1), {{{"aurum_flora:evil_mushroom"}}}),
	force_placement = true,
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

minetest.register_decoration{
	name = "aurum_flora:good_mushroom",
	decoration = "aurum_flora:good_mushroom",
	deco_type = "simple",
	place_on = {"group:soil"},
	sidelen = 16,
	fill_ratio = 0.05,
	num_spawn_by = 1,
	y_min = 0,
	spawn_by = {"group:water", "group:tree"},
}
