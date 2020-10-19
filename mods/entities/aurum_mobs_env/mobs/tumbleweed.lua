local S = aurum.get_translator()

aurum.mobs.register("aurum_mobs_env:tumbleweed", {
	description = S"Tumbleweed",
	longdesc = S"A weed floating stoically past on the wind.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_env_tumbleweed.png"},
		visual_size = {x = 0.6, y = 0.6},

		hp_max = 1,
	},

	initial_data = {
		habitat_nodes = {"group:sand", "group:clay"},
		xmana = 1,
		drops = {"aurum_flora:desert_weed"},
		regen_rate = -1 / 60,
	},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
			"aurum_mobs:regen",
		},

		global_events = {
			stuck = "roam",
			timeout = "roam",
			punch = "",
			lost = "roam",
			interact = "",
			herd_alerted = "",
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
					found_habitat = "go",
					found_random = "go",
				},
			},

			go = {
				actions = {
					"aurum_mobs:go",
					"aurum_mobs:timeout",
				},

				events = {
					reached = "roam",
				},
			},
		},
	},
})

aurum.mobs.register_spawn{
	mob = "aurum_mobs_env:tumbleweed",
	chance = 11 ^ 3,
	biomes = aurum.biomes.get_all_group("desert"),
}
