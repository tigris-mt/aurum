aurum.ultimus.structures = {
	-- Empty room.
	{nil, 10},
}

function aurum.ultimus.register_structure(def)
	local def = b.t.combine(aurum.features.default_decoration_def, def)
	table.insert(aurum.ultimus.structures, {
		def, def.rarity
	})
end

aurum.ultimus.register_structure{
	rarity = 0.1,
	schematic = aurum.structures.f"burn_1.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

aurum.ultimus.register_structure{
	rarity = 1,
	schematic = aurum.structures.f"flesh_tunnel.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

aurum.ultimus.register_structure{
	rarity = 0.1,
	schematic = aurum.structures.f"machine_1.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

aurum.ultimus.register_structure{
	rarity = 0.1,
	schematic = aurum.structures.f"portal_room_1.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

aurum.ultimus.register_structure{
	rarity = 1,
	schematic = aurum.structures.f"regret_brick_pile.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

aurum.ultimus.register_structure{
	rarity = 1,
	schematic = aurum.structures.f"tunnel_1.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
	on_generated = function(c)
		local ph = c:ph(1)

		if #ph > 0 then
			minetest.set_node(ph[1], {name = "aurum_storage:box"})
			c:treasures(ph[1], "main", c:random(2, 4), {
				{
					count = c:random(1, 3),
					preciousness = {0, 4},
					groups = {"food", "tool", "building_block", "light"},
				},
			})
		end
	end,
}

aurum.ultimus.register_structure{
	rarity = 1,
	schematic = aurum.structures.f"wild_room_1.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

aurum.ultimus.register_structure{
	rarity = 1,
	schematic = aurum.structures.f"wood_1.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}
