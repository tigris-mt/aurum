local S = minetest.get_translator()
local HEIGHT = 4
local grow = aurum.flora.stack_grow({"group:soil", "group:sand"}, HEIGHT, nil)

minetest.register_node("aurum_flora:cactus", {
	description = S"Cactus",
	_doc_items_longdesc = S"A prickly plant that grows on sand and soil.",
	tiles = {"aurum_flora_cactus.png"},
	groups = {grow_plant = 1, flammable = 1, dig_chop = 2, dye_source = 1, color_green = 1},
	sounds = aurum.sounds.grass(),
	_on_grow_plant = grow,
	damage_per_second = 10,
	_damage_type = "pierce",
})

minetest.register_decoration{
	name = "aurum_flora:cactus",
	decoration = "aurum_flora:cactus",
	deco_type = "simple",
	place_on = {"group:sand"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.01,
		spread = vector.new(200, 200, 200),
		seed = 266,
		octaves = 3,
		persist = 0.5,
	},
	height_max = HEIGHT,
	biomes = aurum.biomes.get_all_group("desert", {"base"}),
}

minetest.register_abm{
	label = "Cactus Growth",
	nodenames = {"aurum_flora:cactus"},
	interval = 10,
	chance = 10 * HEIGHT / 2,
	action = grow,
}
