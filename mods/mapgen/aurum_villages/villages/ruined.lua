aurum.villages.register_village("aurum_villages:ruined", {
	radius = 16,
	structures = {
		{
			names = {"aurum_villages:ruined_hut"},
			min = 3,
			max = 8,
		},
		{
			names = {"aurum_villages:ruined_hall"},
			min = 1,
			max = 3,
		},
		{
			names = {"aurum_villages:ruined_well"},
			min = 1,
			max = 2,
		},
		--[[
		{
			names = {"aurum_villages:corrupted_temple"},
			min = 0,
			max = 1,
		},
		]]
	},
})

aurum.villages.register_village("aurum_villages:ruined_jungle", {
	radius = 16,
	structures = {
		{
			names = {"aurum_villages:ruined_hut_jungle"},
			min = 3,
			max = 8,
		},
		{
			names = {"aurum_villages:ruined_hall_jungle"},
			min = 1,
			max = 3,
		},
		{
			names = {"aurum_villages:ruined_well_jungle"},
			min = 1,
			max = 2,
		},
		--[[
		{
			names = {"aurum_villages:corrupted_temple"},
			min = 0,
			max = 1,
		},
		]]
	},
})

aurum.features.register_dynamic_decoration{
	decoration = {
		place_on = {"aurum_base:gravel"},
		sidelen = 16,
		fill_ratio = 0.00003,
		biomes = {"aurum_barrens"},
	},

	callback = function(pos, random)
		aurum.villages.generate_village("aurum_villages:ruined", pos, {
			random = random,
		})
	end,
}

aurum.features.register_dynamic_decoration{
	decoration = {
		place_on = {"group:soil"},
		sidelen = 16,
		fill_ratio = 0.00006,
		biomes = {"aurum_jungle"},
	},

	callback = function(pos, random)
		aurum.villages.generate_village("aurum_villages:ruined_jungle", pos, {
			random = random,
		})
	end,
}
