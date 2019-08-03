local m = {}
aurum.biomes.log_decorations = m

table.insert(m, {
	schematic = function(tdef)
		local t = {name = tdef.trunk, param2 = 12}
		return aurum.trees.schematic(vector.new(4, 1, 1), {
			{
				{t, t, t, table.combine(t, {prob = 127})},
			},
		})
	end,
})
