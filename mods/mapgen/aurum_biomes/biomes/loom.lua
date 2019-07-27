local function v_ocean(def)
	return table.combine({
		y_max = 0,
		y_min = -100,
	}, def)
end

aurum.biomes.register_all("aurum:loom", {
	name = "loom_barrens",
	_groups = {"barren"},
	heat_point = 30,
	humidity_point = 30,
	_variants = {
		base = aurum.biomes.v_base{},
		ocean = v_ocean{},
		under = aurum.biomes.v_under{},
	},
})
