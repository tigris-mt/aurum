aurum.villages.structures = {}

function aurum.villages.register_structure(name, def)
	def = b.t.combine(aurum.features.default_decoration_def, {
		size = nil,
		foundation = {"aurum_base:stone"},
	}, def)

	assert(def.size, "structure must specify size")
	assert(type(def.foundation) == "table", "foundation must be a table")

	aurum.villages.structures[name] = def
end
