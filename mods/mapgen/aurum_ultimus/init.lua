local S = aurum.get_translator()

aurum.ultimus = {}

b.dofile("mapgen.lua")
b.dofile("structures.lua")

local box = {
	type = "fixed",
	fixed = {{-0.4, -0.5, -0.4, 0.4, 1.5, 0.4}},
}

minetest.register_node("aurum_ultimus:glowing_obelisk", {
	description = S"Glowing Obelisk",

	drawtype = "nodebox",
	node_box = box,
	tiles = {"aurum_ultimus_glowing_obelisk.png"},

	paramtype2 = "facedir",
	on_place = minetest.rotate_node,

	selection_box = box,
	collision_box = box,

	paramtype = "light",
	light_source = 14,

	is_ground_content = false,
	groups = {dig_pick = 1},

	sounds = aurum.sounds.metal(),
})
