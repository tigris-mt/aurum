aurum.villages.villages = {}

function aurum.villages.register_village(name, def)
	def = b.t.combine({
		radius = 40,
		path_width = 3,
		path_spacing = 12,
		path_clear_above = 2,
		structures = {},
		path = {
			base = "aurum_base:stone_brick",
			stairs = "aurum_base:stone_brick_sh_stairs",
		},
	}, def)

	aurum.villages.villages[name] = def
end
