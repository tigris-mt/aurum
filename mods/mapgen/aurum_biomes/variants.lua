function aurum.biomes.v_base(def)
	return b.t.combine({
		y_min = 1,
	}, def)
end

function aurum.biomes.v_ocean(def)
	return b.t.combine({
		node_top = "aurum_base:sand",
		depth_top = 1,
		node_filler = "aurum_base:sand",
		depth_filler = 3,
		y_max = 0,
		y_min = -50,
		node_cave_liquid = "aurum_base:water_source",
		vertical_blend = 1,
	}, def)
end

function aurum.biomes.v_under(def)
	return b.t.combine({
		y_max = -50,
		y_min = b.WORLD.min.y,
	}, def)
end
