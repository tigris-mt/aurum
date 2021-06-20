aurum.villages.villages = {}

function aurum.villages.register_village(name, def)
	def = b.t.combine({
		radius = 40,
		structures = {},
		path = {
			base = "aurum_base:stone_brick",
			stairs = "aurum_base:stone_brick_sh_stairs",
			ladder = "aurum_ladders:wood",
		},
	}, def)

	aurum.villages.villages[name] = def
end
