aurum.villages.register_village("aurum_villages:ruined", {
	radius = 16,
	structures = {
		{
			names = {"aurum_villages:ruined_hut"},
			min = 3,
			max = 8,
		},
	},
})

aurum.features.register_dynamic_decoration{
	decoration = {
		place_on = {"aurum_base:gravel"},
		sidelen = 16,
		fill_ratio = 0.00001,
		biomes = {"aurum_barrens"},
	},

	callback = function(pos, random)
		aurum.villages.generate_village("aurum_villages:ruined", pos, {
			random = random,
		})
	end,
}
