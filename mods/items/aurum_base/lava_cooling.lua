local S = minetest.get_translator()

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "cools_lava") > 0 then
		return S"This node will cool lava nodes when next to them, turning them into something such as stone."
	end
	return ""
end)

doc.sub.items.register_factoid("nodes", "use", function(itemstring, def)
	if minetest.get_item_group(itemstring, "lava") > 0 then
		return S("This node will become @1 when next to a lava cooling node such as water.", def._lava_cool_node or "aurum_base:stone")
	end
	return ""
end)

if minetest.settings:get_bool("aurum.base.cool_lava", true) then
	minetest.register_abm{
		label = "Lava Cooling",
		nodenames = {"group:lava"},
		neighbors = {"group:cools_lava"},
		interval = 2,
		chance = 2,
		catch_up = false,
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
