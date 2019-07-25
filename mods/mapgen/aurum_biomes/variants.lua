function aurum.biomes.v_base(def)
	return table.combine({
		y_min = 1,
	}, def)
end


function aurum.biomes.v_ocean(def)
	return table.combine({
		node_top = "aurum_base:sand",
		depth_top = 1,
		node_filler = "aurum_base:sand",
		depth_filler = 3,
		y_max = 0,
		y_min = -100,
		node_cave_liquid = "aurum_base:water_source",
	}, def)
end

function aurum.biomes.v_under(def)
	return table.combine({
		y_max = -100,
		y_min = aurum.WORLD.min.y,
	}, def)
end
