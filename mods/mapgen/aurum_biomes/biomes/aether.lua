local d = {
	node_water = "air",
	node_cave_liquid = "air",
}

local function v_n(f, td)
	return function(def) return aurum.biomes[f](b.t.combine(d, td or {}, def)) end
end

local v_base = v_n("v_base", {
	y_min = 4,
})

local v_under = v_n("v_under", {
	y_max = 3,
	node_stone = "aurum_base:aether_source",
})

aurum.biomes.register_all("aurum:aether", {
	name = "aether_barrens",
	heat_point = 50,
	humidity_point = 50,
	_variants = {
		base = v_base{
			node_top = "aurum_base:grass",
			depth_top = 1,
			node_filler = "aurum_base:dirt",
			depth_filler = 4,
		},
		under = v_under{},
	},
})
