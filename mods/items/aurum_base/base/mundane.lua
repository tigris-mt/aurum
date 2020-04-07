local S = minetest.get_translator()

minetest.register_node("aurum_base:stone", {
	description = S("Stone"),
	_doc_items_longdesc = S("An extremely common node. Often surrounds ores."),
	_doc_items_hidden = false,
	tiles = {"aurum_base_stone.png"},
	sounds = aurum.sounds.stone(),
	groups = {dig_pick = 3, dig_hammer = 3, stone = 1, cook_temp = 10, shapable = 1},
	_hammer_drop = "aurum_base:gravel",
})

minetest.register_node("aurum_base:sand", {
	description = S"Sand",
	_doc_items_longdesc = S"Soft and unstable grains.",
	tiles = {"aurum_base_sand.png"},
	sounds = aurum.sounds.sand(),
	groups = {dig_dig = 3, falling_node = 1, sand = 1, cook_temp = 10},
})

minetest.register_node("aurum_base:gravel", {
	description = S("Gravel"),
	_doc_items_longdesc = S("Rough, unstable bits of stone."),
	tiles = {"aurum_base_gravel.png"},
	sounds = aurum.sounds.gravel(),
	groups = {dig_dig = 3, falling_node = 1},
})

minetest.register_node("aurum_base:dirt", {
	description = S("Dirt"),
	_doc_items_longdesc = S("Decayed material and bits of rock."),
	_doc_items_hidden = false,
	tiles = {"aurum_base_dirt.png"},
	sounds = aurum.sounds.dirt(),
	groups = {soil = 1, dig_dig = 3, dirt_base = 1},
})

minetest.register_node("aurum_base:grass", {
	description = S("Grass"),
	_doc_items_longdesc = S("Grassy dirt, a mass of plant matter."),
	_doc_items_hidden = false,
	tiles = {"aurum_base_grass.png"},
	sounds = aurum.sounds.grass(),
	groups = {soil = 1, dig_dig = 3, dirt_spread = 1, dirt_smother = 1, grow_plant = 1, grass_soil = 1},
	_on_grow_plant = aurum.base.dirt_spread,
})

minetest.register_node("aurum_base:dark_grass", {
	description = S"Dark Grass",
	_doc_items_longdesc = S"A dark variant of grass found in hot, wet areas.",
	_doc_items_hidden = false,
	tiles = {"aurum_base_grass.png^[colorize:#000000:127"},
	sounds = aurum.sounds.grass(),
	groups = {soil = 1, dig_dig = 3, dirt_spread = 1, dirt_smother = 1, grow_plant = 1, grass_soil = 1},
	_on_grow_plant = aurum.base.dirt_spread,
})

minetest.register_node("aurum_base:snow", {
	description = S"Snow",
	tiles = {"aurum_base_snow.png"},
	sounds = aurum.sounds.snow(),
	groups = {dig_dig = 3, cools_lava = 1, snow = 1, fall_damage_add_percent = -50, shapable = 1},
})

minetest.register_node("aurum_base:ice", {
	description = S"Ice",
	tiles = {"aurum_base_ice.png"},
	paramtype = "light",
	is_ground_content = false,
	sounds = aurum.sounds.glass(),
	groups = {dig_pick = 3, ice = 1, cools_lava = 1, slippery = 3, shapable = 1},
})

minetest.register_node("aurum_base:ground_ice", {
	description = S"Ground Ice",
	_doc_items_create_entry = false,
	tiles = {"aurum_base_ice.png"},
	paramtype = "light",
	sounds = aurum.sounds.glass(),
	groups = {dig_pick = 3, ice = 1, cools_lava = 1, slippery = 3, not_in_creative_inventory = 1},
	drop = "aurum_base:ice",
})

doc.add_entry_alias("nodes", "aurum_base:ice", "nodes", "aurum_base:ground_ice")
