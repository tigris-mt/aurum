local S = minetest.get_translator()

aurum.mobs.register("aurum_mobs_animals:rat", {
	description = S"Rat",
	longdesc = S"A common miniscule mammal that may be considered an annoyance.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_animals_rat.png"},
		visual_size = {x = 0.6, y = 0.6},

		hp_max = 2,
	},

	initial_data = {
		habitat_nodes = {"group:stone", "aurum_base:stone_brick", "aurum_base:gravel"},
		drops = {"aurum_base:stone"},
	},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
		},

		global_events = {
			stuck = "roam",
			timeout = "roam",
			punch = "flee",
			lost = "roam",
		},

		states = {
			init = {
				events = {
					init = "roam",
				},
			},

			roam = {
				actions = {
					"aurum_mobs:find_habitat",
					"aurum_mobs:find_random",
				},

				events = {
					found = "go",
				},
			},

			go = {
				actions = {
					"aurum_mobs:go",
				},

				events = {
					reached = "roam",
				},
			},

			flee = {
				actions = {
					"aurum_mobs:adrenaline",
					"aurum_mobs:flee",
				},
			},
		},
	},
})

aurum.mobs.register_spawn{
	mob = "aurum_mobs_animals:rat",
	chance = 2000,
	biomes = aurum.biomes.get_all_group("aurum:aurum"),
}
