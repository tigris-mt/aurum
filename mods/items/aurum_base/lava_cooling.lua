if minetest.settings:get_bool("aurum.base.cool_lava", true) then
	minetest.register_abm{
		label = "Lava Cooling",
		nodenames = {"group:lava"},
		neighbors = {"group:cools_lava"},
		interval = 2,
		chance = 2,
		action = function(pos, node)
			local def = minetest.registered_nodes[node.name]
			minetest.set_node(pos, {name = def._lava_cool_node or "aurum_base:stone"})
			minetest.sound_play("default_cool_lava", {
				pos = pos,
				gain = 1 / 4,
				max_hear_distance = 16,
			})
		end,
	}
end
