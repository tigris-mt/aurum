local defs = {
	{
		schematic = aurum.structures.f"standing_stone_1.mts",
		offset = -2,
	},
	{
		schematic = aurum.structures.f"standing_stone_2.mts",
		offset = -3,
	},
}

for _,def in ipairs(defs) do
	def = b.t.combine({
		schematic = nil,
		offset = 0,
	}, def)

	aurum.features.register_decoration{
		place_on = {"group:soil", "aurum_base:gravel", "group:stone", "group:snow"},
		rarity = 1 / (11 ^ 3) / #defs,
		biomes = aurum.biomes.get_all_group("barren", {"base"}),
		schematic = def.schematic,

		on_offset = function(c)
			return vector.add(c.pos, vector.new(0, def.offset, 0))
		end,
	}
end

