local S = minetest.get_translator()
local HEIGHT = 4
local grow = aurum.flora.stack_grow({"group:soil", "group:sand"}, HEIGHT, "group:water")

aurum.flora.register("aurum_flora:reed", {
	description = S"Tubal Reed",
	_doc_items_longdesc = S"A useful reed that grows on soil and sand by water.",
	tiles = {"aurum_flora_reed.png"},
	groups = {flora = 0, attached_node = 0},
	_on_grow_plant = grow,
	waving = 0,
	buildable_to = false,
	selection_box = {
		type = "fixed",
		fixed = {
			-0.35, -0.5, -0.35,
			0.35, 0.5, 0.35,
		},
	},

	-- Recursively dig up.
	after_dig_node = function(pos, node, _, digger)
		local above = vector.add(pos, vector.new(0, 1, 0))
		local anode = minetest.get_node(above)
		if anode.name == node.name then
			minetest.dig_node(above)
		end
	end,
})

minetest.register_craft{
	type = "fuel",
	recipe = "aurum_flora:reed",
	burntime = 3,
}

minetest.register_decoration{
	name = "aurum_flora:reed",
	decoration = "aurum_flora:reed",
	deco_type = "simple",
	place_on = {"group:sand"},
	sidelen = 16,
	fill_ratio = 0.1,
	height_max = HEIGHT,
	num_spawn_by = 1,
	spawn_by = "group:water",
}

minetest.register_abm{
	label = "Tubal Reed Growth",
	nodenames = {"aurum_flora:reed"},
	neighbors = {"group:water"},
	interval = 10,
	chance = 10 * HEIGHT / 2,
	action = grow,
}
