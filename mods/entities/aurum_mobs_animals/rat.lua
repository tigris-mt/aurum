local S = minetest.get_translator()

aurum.mobs.register("aurum_mobs_animals:rat", {
	description = S"Rat",
	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_animals_rat.png"},
		visual_size = {x = 0.6, y = 0.6},

		hp_max = 2,
	},
	gemai = {
		global_actions = {
			"aurum_mobs:physics",
		},

		global_events = {
			stuck = "roam",
			timeout = "roam",
			punch = "",
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
					found = "go_place",
				},
			},

			go_place = {
				actions = {
					"aurum_mobs:go",
				},

				events = {
					reached = "roam",
				},
			},
		},
	},
	habitat_nodes = {"group:stone", "aurum_base:stone_brick", "aurum_base:gravel"},
})
