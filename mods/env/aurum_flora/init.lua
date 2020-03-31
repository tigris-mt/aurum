aurum.flora = {}

-- Register a flora node. Passes to minetest.register_node() with suitable defaults set.
function aurum.flora.register(name, def)
	minetest.register_node(name, b.t.combine({
		drawtype = "plantlike",
		waving = 1,
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		sounds = aurum.sounds.grass(),
		_on_grow_plant = aurum.flora.spread,
	}, def, {
		groups = b.t.combine({
			dig_snap = 3,
			flora = 1,
			flammable = 1,
			attached_node = 1,
			grow_plant = 1,
		}, def.groups or {})
	}))
end

minetest.register_craft{
	type = "fuel",
	recipe = "group:flammable,flora",
	burntime = 3,
}

minetest.register_craft{
	output = "aurum_base:paste 2",
	recipe = {
		{"group:flora", "group:flora", "group:flora"},
		{"group:flora", "group:flora", "group:flora"},
	},
}

b.dofile("spreading.lua")
b.dofile("stack_grow.lua")

b.dodir("flora")
