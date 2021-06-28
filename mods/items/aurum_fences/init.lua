aurum.fences = {}

function aurum.fences.register(name, def)
	def = b.t.combine({
		description = "?",
		texture = "aurum_base_stone.png",
		node_def = {},
	}, def)

	minetest.register_node(name, b.t.combine({
		description = def.description,
		tiles = {def.texture},
		drawtype = "fencelike",
		paramtype = "light",
		collision_box = {
			type = "fixed",
			fixed = {-0.2, -0.5, -0.2, 0.2, 0.5, 0.2},
		},
	}, def.node_def))
end

b.dofile("default_fences.lua")
