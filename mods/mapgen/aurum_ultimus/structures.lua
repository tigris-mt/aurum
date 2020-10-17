aurum.ultimus.structures = {
	-- Empty room.
	{nil, 7},
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
	schematic = aurum.structures.f"doors_1.mts",
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
	rarity = 1,
	schematic = aurum.structures.f"garden_1.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

local ladder_step = {{"aurum_features:ph_1"}}

aurum.ultimus.register_structure{
	rarity = 3,
	schematic = aurum.features.schematic(vector.new(1, 9, 1), {
		ladder_step,
		ladder_step,
		ladder_step,
		ladder_step,
		ladder_step,
		ladder_step,
		ladder_step,
		ladder_step,
		ladder_step,
	}),
	on_generated = function(c)
		for _,pos in ipairs(c:ph(1)) do
			minetest.set_node(pos, {
				name = "aurum_ladders:wood",
				param2 = minetest.dir_to_wallmounted(c:dir(vector.new(0, 0, 1))),
			})
		end
	end,
}

aurum.ultimus.register_structure{
	rarity = 0.5,
	schematic = aurum.structures.f"machine_1.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

aurum.ultimus.register_structure{
	rarity = 1,
	schematic = aurum.structures.f"machine_2.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
	on_generated = function(c)
		for i=1,c:random(0, #c:ph(1)) do
			minetest.set_node(c:ph(1)[i], {name = "aurum_storage:box"})
			c:treasures(c:ph(1)[i], "main", c:random(1, 3), {
				{
					count = 1,
					preciousness = {1, 5},
					groups = {"building_block", "tool", "raw", "crafting_component", "building_block", "dye", "processed", "worker"},
				},
			})
		end

		for i=1,c:random(0, #c:ph(2)) do
			local name = b.t.choice({
				"aurum_cook:smelter",
				"aurum_cook:oven",
				"aurum_stamp:stamper",
				"aurum_enchants:table",
				"aurum_enchants:copying_desk",
				"aurum_rods:table",
			}, function(...) return c:random(...) end)

			minetest.set_node(c:ph(2)[i], {name = name})

			if name == "aurum_cook:smelter" or name == "aurum_cook:oven" then
				c:treasures(c:ph(2)[i], "fuel", 1, {
					{
						count = 1,
						preciousness = {1, 5},
						groups = {"fuel"},
					},
				})
			end
		end
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
	schematic = aurum.structures.f"regret_1.mts",
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
	schematic = aurum.structures.f"summon_scroll_1.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
	on_generated = function(c)
		local ph = c:ph(1)

		if #ph > 0 then
			minetest.set_node(ph[1], {name = "aurum_storage:shell_box"})
			minetest.get_meta(ph[1]):get_inventory():set_list("main", b.t.duplicate(aurum.magic.new_spell_scroll("summon_avatar", 1), c:random(1, 5)))
		end
	end,
}

aurum.ultimus.register_structure{
	rarity = 3,
	make_schematic = function(c)
		return aurum.features.schematic(vector.new(1, 1, 1), {
			{{"aurum_features:ph_1"}},
		})
	end,
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
	on_generated = function(c)
		local ph = c:ph(1)

		if #ph > 0 then
			minetest.set_node(ph[1], {name = b.t.choice({
				"aurum_trees:oak_sapling",
				"aurum_trees:birch_sapling",
				"aurum_trees:pander_sapling",
				"aurum_trees:white_crystal_sapling",
			}, function(...) return c:random(...) end)})

			minetest.get_meta(ph[1]):set_int("sapling_all_terrain", 1)
			minetest.get_meta(ph[1]):set_int("sapling_replace", 1)
			minetest.get_meta(ph[1]):set_int("sapling_rare", 1)

			minetest.get_node_timer(ph[1]):start(0.1)
		end
	end,
}

aurum.ultimus.register_structure{
	rarity = 1,
	make_schematic = function(c)
		return aurum.features.schematic(vector.new(1, 1, 1), {
			{{"aurum_ultimus:glowing_obelisk"}},
		})
	end,
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
	schematic = aurum.structures.f"tunnel_2.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
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
	schematic = aurum.structures.f"wild_room_2.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

aurum.ultimus.register_structure{
	rarity = 1,
	schematic = aurum.structures.f"wild_room_3.mts",
	on_offset = function(c)
		return vector.add(c.pos, vector.new(0, 1, 0))
	end,
}

aurum.ultimus.register_structure{
	rarity = 1,
	schematic = aurum.structures.f"wild_room_4.mts",
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
