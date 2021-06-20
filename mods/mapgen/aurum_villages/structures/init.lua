aurum.villages.structures = {}

function aurum.villages.register_structure(name, def)
	def = b.t.combine(aurum.features.default_decoration_def, {
		size = nil,
		foundation = {"aurum_base:stone"},
		offset = vector.new(0, 0, 0),
	}, def)

	def.on_offset = function(context)
		return vector.add(context.pos, def.offset)
	end

	assert(def.size, "structure must specify size")
	assert(type(def.foundation) == "table", "foundation must be a table")

	aurum.villages.structures[name] = def
end
