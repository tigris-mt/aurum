aurum.flora = {}

-- Register a flora node. Passes to minetest.register_node() with suitable defaults set.
function aurum.flora.register(name, def)
	minetest.register_node(name, table.combine({
		drawtype = "plantlike",
		waving = 1,
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		sounds = aurum.sounds.grass(),
		_on_grow_plant = aurum.flora.spread,
	}, def, {
		groups = table.combine({
			dig_snap = 3,
			flora = 1,
			flammable = 1,
			attached_node = 1,
			grow_plant = 1,
		}, def.groups or {})
	}))
end

aurum.dofile("spreading.lua")
aurum.dofile("stack_grow.lua")

aurum.dofile("flowers.lua")
aurum.dofile("papyrus.lua")
aurum.dofile("weeds.lua")
