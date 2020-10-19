local S = aurum.get_translator()

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
