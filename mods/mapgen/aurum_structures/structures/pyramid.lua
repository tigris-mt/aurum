function aurum.structures.register_pyramid(def)
	local def = b.t.combine({
		primary_node = "aurum_base:stone_brick",
		alternative_node = "aurum_base:stone",
		liquid_node = "aurum_base:lava_source",
	}, def)
end
