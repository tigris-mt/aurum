local S = minetest.get_translator()

aurum.mobs.register("aurum_mobs_animals:goat", {
	description = S"Goat",
	longdesc = S"A well-known animal, often domesticated for its meat and milk.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_animals_goat.png"},
		visual_size = {x = 1.5, y = 1},

		hp_max = 14,
	},

	initial_data = {
		habitat_nodes = {"group:soil"},
		drops = {"aurum_animals:raw_meat 5", "aurum_animals:bone 6"},
		xmana = 4,
		pathfinder = b.t.combine(aurum.mobs.DEFAULT_PATHFINDER, {
			jump_height = 3,
		}),
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
	mob = "aurum_mobs_animals:goat",
	chance = 22 ^ 3,
	biomes = aurum.biomes.get_all_group("green", {"base"}),
}
