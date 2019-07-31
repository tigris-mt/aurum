local S = minetest.get_translator()

minetest.register_node("aurum_base:stone", {
	description = S("Stone"),
	_doc_items_longdesc = S("An extremely common node. Often surrounds ores."),
	_doc_items_hidden = false,
	tiles = {"aurum_base_stone.png"},
	is_ground_content = true,
	sounds = aurum.sounds.stone(),
	groups = {dig_pick = 3, dig_hammer = 3, stone = 1, cook_temp = 10},
	_hammer_drop = "aurum_base:gravel",
})

minetest.register_node("aurum_base:regret", {
	description = S"Regret",
	_doc_items_longdesc = S"The stuff of the Loom. All old fears, lost hopes, failures, and corruptions are regrets of the world to be regurgitated into existence.",
	tiles = {"aurum_base_stone.png^[colorize:#440000:127"},
	is_ground_content = true,
	sounds = aurum.sounds.stone(),
	groups = {dig_pick = 2, level = 2, cook_temp = 15},
})

minetest.register_node("aurum_base:sand", {
	description = S"Sand",
	_doc_items_longdesc = S"Soft and unstable grains.",
	tiles = {"aurum_base_sand.png"},
	is_ground_content = true,
	sounds = aurum.sounds.sand(),
	groups = {dig_dig = 3, falling_node = 1, sand = 1},
})

minetest.register_node("aurum_base:gravel", {
	description = S("Gravel"),
	_doc_items_longdesc = S("Rough, unstable bits of stone."),
	tiles = {"aurum_base_gravel.png"},
	is_ground_content = true,
	sounds = aurum.sounds.gravel(),
	groups = {dig_dig = 3, falling_node = 1},
})

minetest.register_node("aurum_base:dirt", {
	description = S("Dirt"),
	_doc_items_longdesc = S("Decayed material and bits of rock."),
	_doc_items_hidden = false,
	tiles = {"aurum_base_dirt.png"},
	is_ground_content = true,
	sounds = aurum.sounds.dirt(),
	groups = {soil = 1, dig_dig = 3, dirt_base = 1},
})

minetest.register_node("aurum_base:grass", {
	description = S("Grass"),
	_doc_items_longdesc = S("Grassy dirt, a mass of plant matter."),
	_doc_items_hidden = false,
	tiles = {"aurum_base_grass.png"},
	is_ground_content = true,
	sounds = aurum.sounds.grass(),
	groups = {soil = 1, dig_dig = 3, dirt_spread = 1, dirt_smother = 1, grow_plant = 1, grass_soil = 1},
	_on_grow_plant = aurum.base.dirt_spread,
})

minetest.register_node("aurum_base:dark_grass", {
	description = S"Dark Grass",
	_doc_items_longdesc = S"A dark variant of grass found in hot, wet areas.",
	_doc_items_hidden = false,
	tiles = {"aurum_base_grass.png^[colorize:#000000:127"},
	is_ground_content = true,
	sounds = aurum.sounds.grass(),
	groups = {soil = 1, dig_dig = 3, dirt_spread = 1, dirt_smother = 1, grow_plant = 1, grass_soil = 1},
	_on_grow_plant = aurum.base.dirt_spread,
})

minetest.register_node("aurum_base:snow", {
	description = S"Snow",
	tiles = {"aurum_base_snow.png"},
	is_ground_content = false,
	sounds = aurum.sounds.snow(),
	groups = {dig_dig = 3, cools_lava = 1, snow = 1, fall_damage_add_percent = -50},
})

minetest.register_node("aurum_base:ice", {
	description = S"Ice",
	tiles = {"aurum_base_ice.png"},
	paramtype = "light",
	is_ground_content = false,
	sounds = aurum.sounds.glass(),
	drawtype = "glasslike",
	groups = {dig_pick = 3, cools_lava = 1, slippery = 3},
})

minetest.register_node("aurum_base:cave_ice", {
	description = S"Cave Ice",
	_doc_items_create_entry = false,
	tiles = {"aurum_base_ice.png"},
	paramtype = "light",
	is_ground_content = true,
	sounds = aurum.sounds.glass(),
	groups = {dig_pick = 3, cools_lava = 1, slippery = 3, not_in_creative_inventory = 1},
	drop = "aurum_base:ice",
})

doc.add_entry_alias("nodes", "aurum_base:ice", "nodes", "aurum_base:cave_ice")

minetest.register_node("aurum_base:foundation", {
	description = S("Foundation"),
	_doc_items_longdesc = S"Some speak of the 'Foundations of the World'. Here they are.",
	tiles = {"aurum_base_stone.png^[colorize:#000000:200"},
	sounds = aurum.sounds.stone(),
	is_ground_content = false,
	diggable = false,
	drop = "",
	on_blast = function() end,
	can_dig = function() return false end,
})

minetest.register_node("aurum_base:limit", {
	description = S("Limit"),
	_doc_items_longdesc = S"The inexorable dimensional limiter. Only powerful portals can push through.",
	tiles = {"aurum_base_stone.png^[colorize:#FFFFFF:200"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	diggable = false,
	drop = "",
	on_blast = function() end,
	can_dig = function() return false end,
})
