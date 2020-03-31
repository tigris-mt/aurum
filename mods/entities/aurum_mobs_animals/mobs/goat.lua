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
		food = {"group:flora"},
		habitat_nodes = {"group:soil"},
		drops = {"aurum_animals:raw_meat 5", "aurum_animals:bone 6"},
		xmana = 4,
		pathfinder = b.t.combine(aurum.mobs.DEFAULT_PATHFINDER, {
			jump_height = 3,
		}),
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {pierce = 3, impact = 3},
		}),
	},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
			"aurum_mobs:regen_milk",
			"aurum_mobs:reduce_satiation",
		},

		global_events = {
			stuck = "roam",
			timeout = "roam",
			punch = "fight",
			lost = "roam",
			interact = "interact",
			herd_alerted = "go_fight",
		},

		states = {
			init = {
				events = {
					init = "roam",
				},
			},

			roam = {
				actions = {
					"aurum_mobs:find_mate",
					"aurum_mobs:find_food",
					"aurum_mobs:find_habitat",
					"aurum_mobs:find_random",
				},

				events = {
					found_mate = "go_mate",
					found_food = "go_food",
					found_habitat = "go",
					found_random = "go",
				},
			},

			stand = {
				actions = {
					"aurum_mobs:find_food",
					"aurum_mobs:timeout",
				},
				events = {
					found_food = "go_food",
				},
			},

			mate = {
				actions = {
					"aurum_mobs:check_mate",
					"aurum_mobs:mate"
				},
				events = {
					lost_mate = "roam",
					done_mate = "roam",
				},
			},

			go_mate = {
				actions = {
					"aurum_mobs:check_mate",
					"aurum_mobs:adrenaline",
					"aurum_mobs:go",
					"aurum_mobs:timeout",
				},
				events = {
					reached = "mate",
					lost_mate = "roam",
				}
			},

			go_food = {
				actions = {
					"aurum_mobs:check_target_food",
					"aurum_mobs:go",
					"aurum_mobs:timeout",
				},
				events = {
					reached = "roam",
					lost_food = "roam",
				},
			},

			go = {
				actions = {
					"aurum_mobs:go",
					"aurum_mobs:timeout",
				},

				events = {
					reached = "stand",
				},
			},

			fight = {
				actions = {
					"aurum_mobs:adrenaline",
					"aurum_mobs:alert_herd",
					"aurum_mobs:attack",
				},
				events = {
					interact = "",
					noreach = "go_fight",
					herd_alerted = "",
				},
			},

			interact = {
				actions = {
					"aurum_mobs:eat_hand",
					"aurum_mobs:milk",
					"gemai:always",
				},
				events = {
					ate = "roam",
					milked = "roam",
					always = "roam",
				},
			},

			go_fight = {
				actions = {
					"aurum_mobs:adrenaline",
					"aurum_mobs:alert_herd",
					"aurum_mobs:go",
					"aurum_mobs:timeout",
				},
				events = {
					interact = "",
					reached = "fight",
					herd_alerted = "",
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

