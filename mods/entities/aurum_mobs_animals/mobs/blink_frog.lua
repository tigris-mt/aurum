local S = aurum.get_translator()

aurum.mobs.register("aurum_mobs_animals:blink_frog", {
	description = S"Blink frog",
	longdesc = S"A small, aggressive animal",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_animals_blink_frog.png"},
		visual_size = {x = 1, y = 1},

		hp_max = 10,
	},

	initial_data = {
		drops = {"aurum_animals:raw_meat 1", "aurum_animals:bone 1"},
		habitat_nodes = {"group:soil", "aurum_base:aether_shell"},
		xmana = 4,
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {pierce = 2},
			effects = {
				["aurum_effects:poison"] = {level = 1, duration = 5},
			},
		}),
		base_speed = 1,
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
			punch = "fight",
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
					"aurum_mobs:light_switch",
				},

				events = {
					light_day = "passive_roam",
					light_night = "hostile_roam",
				},
			},

			stand = {
				actions = {
					"aurum_mobs:light_switch",
				},

				events = {
					light_day = "passive_stand",
					light_night = "hostile_stand",
				},
			},

			hostile_roam = {
				actions = {
					"aurum_mobs:find_prey",
					"aurum_mobs:find_habitat",
					"aurum_mobs:find_random",
				},

				events = {
					found_prey = "go_fight",
					found_habitat = "go",
					found_random = "go",
				},
			},

			hostile_stand = {
				actions = {
					"aurum_mobs:find_prey",
					"aurum_mobs:timeout",
				},

				events = {
					found_prey = "go_fight",
				},
			},

			passive_roam = {
				actions = {
					"aurum_mobs:find_habitat",
					"aurum_mobs:find_random",
				},

				events = {
					found_habitat = "go",
					found_random = "go",
				},
			},

			passive_stand = {
				actions = {
					"aurum_mobs:timeout",
				},
			},

			go = {
				actions = {
					"aurum_mobs:teleport",
					"aurum_mobs:timeout",
				},

				events = {
					reached = "stand",
				},
			},

			go_fight = {
				actions = {
					"aurum_mobs:adrenaline",
					"aurum_mobs:teleport",
					"aurum_mobs:timeout",
				},
				events = {
					reached = "fight",
				},
			},

			fight = {
				actions = {
					"aurum_mobs:adrenaline",
					"aurum_mobs:attack",
				},
				events = {
					noreach = "go_fight",
				},
			},
		},
	},
})

aurum.mobs.register_spawn{
	mob = "aurum_mobs_animals:blink_frog",
	chance = 26 ^ 3,
	biomes = b.set.to_array(b.set._or(b.set(aurum.biomes.get_all_group("green")), b.set(aurum.biomes.get_all_group("forest")), b.set(aurum.biomes.get_all_group("aurum:aether")))),
	light_max = 9,
}
