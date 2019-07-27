aurum.biomes.register_all("aurum:loom", {
	name = "loom_barrens",
	_groups = {"barren"},
	heat_point = 30,
	humidity_point = 30,
	_variants = {
		base = aurum.biomes.v_base{
			node_top = "aurum_base:gravel",
			depth_top = 1,
			node_filler = "aurum_base:stone",
			depth_fillter = 1,
		},
		ocean = aurum.biomes.v_ocean{
			node_top = "aurum_base:stone",
			node_filler = "aurum_base:stone",
		},
		under = aurum.biomes.v_under{},
	},
})
