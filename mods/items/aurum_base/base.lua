local S = minetest.get_translator()

minetest.register_node("aurum_base:stone", {
	description = S("Stone"),
	_doc_items_longdesc = S("An extremely common node. Often surrounds ores."),
	_doc_items_hidden = false,
	tiles = {"aurum_base_stone.png"},
	is_ground_content = true,
	sounds = aurum.sounds.stone(),
	groups = {dig_pick = 1, dig_hand = 5},
})

minetest.register_node("aurum_base:dirt", {
	description = S("Dirt"),
	_doc_items_longdesc = S("Decayed material and bits of rock."),
	_doc_items_hidden = false,
	tiles = {"aurum_base_dirt.png"},
	is_ground_content = true,
	sounds = aurum.sounds.dirt(),
	groups = {soil = 1, dig_shovel = 1, dig_hand = 3},
})

minetest.register_node("aurum_base:grass", {
	description = S("Grass"),
	_doc_items_longdesc = S("Grassy dirt, a mass of plant matter."),
	_doc_items_hidden = false,
	tiles = {"aurum_base_grass.png"},
	is_ground_content = true,
	sounds = aurum.sounds.grass(),
	groups = {soil = 1, dig_shovel = 1, dig_hand = 3},
})
