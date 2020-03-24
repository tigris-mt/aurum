local S = minetest.get_translator()

minetest.register_node("aurum_base:aether_shell", {
	description = S"Aether Shell",
	_doc_items_longdesc = S"Hard organic material interlaced with old magic. Remarkably similar to fragment of snail shell.",
	tiles = {"aurum_base_aether_shell.png"},
	sounds = aurum.sounds.stone(),
	groups = {dig_pick = 2, level = 2},
	paramtype = "light",
	light_source = 1,
})

minetest.register_node("aurum_base:aether_skin", {
	description = S"Aether Skin",
	_doc_items_longdesc = S"Tough, leathery skin.",
	tiles = {"aurum_base_aether_skin.png"},
	sounds = aurum.sounds.flesh(),
	groups = {dig_dig = 2, dig_chop = 2, level = 2, bouncy = 80, fall_damage_add_percent = -30},
	paramtype = "light",
	light_source = 2,
})

minetest.register_node("aurum_base:aether_flesh", {
	description = S"Aether Flesh",
	_doc_items_longdesc = S"Strange flesh.",
	tiles = {"aurum_base_aether_flesh.png"},
	sounds = aurum.sounds.flesh(),
	groups = {dig_dig = 2, dig_chop = 2, slippery = 2, fall_damage_add_percent = -70, bouncy = 20},
	paramtype = "light",
	light_source = 3,
})
