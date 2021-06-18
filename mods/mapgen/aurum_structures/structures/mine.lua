local defs = {
	{
		schematic = aurum.structures.f"mine_1.mts",
		offset = -1,
	},
	{
		schematic = aurum.structures.f"mine_2.mts",
		offset = -7,
	},
	{
		schematic = aurum.structures.f"mine_3.mts",
		offset = -1,
	},
}

for _,def in ipairs(defs) do
	def = b.t.combine({
		schematic = nil,
		offset = 0,
	}, def)

	aurum.features.register_decoration{
		place_on = {"group:stone"},
		rarity = 1 / (13 ^ 3) / #defs,
		biomes = aurum.biomes.get_all_group("all", {"under"}),
		schematic = def.schematic,

		on_offset = function(c)
			return vector.add(c.pos, vector.new(0, def.offset, 0))
		end,

		on_generated = function(c)
			for _,pos in ipairs(c:ph(1)) do
				minetest.set_node(pos, {name = "aurum_storage:box"})
				c:treasures(pos, "main", c:random(0, 3), {
					{
						count = 2,
						preciousness = {0, 6},
						groups = {"minetool"},
					},
					{
						count = 2,
						preciousness = {0, 6},
						groups = {"transport_vehicle", "transport_structure"},
					},
					{
						count = 1,
						preciousness = {0, 6},
						groups = {"equipment", "food"},
					},
				})
			end
		end,
	}
end


