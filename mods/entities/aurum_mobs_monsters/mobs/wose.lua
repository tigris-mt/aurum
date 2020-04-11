local S = minetest.get_translator()

aurum.mobs.register("aurum_mobs_monsters:wose", {
	description = S"Wose",
	longdesc = S"Born in the depths of Primus Hortum, this creature desires only to reclaim dust to dust and mud to mud. It is not aggressive in the sunlight.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_monsters_wose.png"},
		visual_size = {x = 1, y = 2},

		hp_max = 60,
	},

	initial_data = {
		drops = {"aurum_trees:pander_sapling", "aurum_farming:fertilizer"},
		habitat_nodes = {"group:leaves"},
		xmana = 20,
		pathfinder = b.t.combine(aurum.mobs.DEFAULT_PATHFINDER, {
			clearance_height = 2,
			drop_height = -1,
		}),
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {pierce = 6, impact = 6},
		}),
		base_speed = 1,
	},

	armor_groups = {chill = 50, burn = 150, pierce = 50, impact = 75, psyche = 110},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
		},

		global_events = {
			stuck = "roam",
			timeout = "roam",
			punch = "fight",
			lost = "roam",
			interact = "",
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
					"aurum_mobs:go",
					"aurum_mobs:timeout",
				},

				events = {
					reached = "stand",
				},
			},

			go_fight = {
				actions = {
					"aurum_mobs:adrenaline",
					"aurum_mobs:go",
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
	mob = "aurum_mobs_monsters:wose",
	chance = 17 ^ 3,
	biomes = b.set.to_array(b.set._and(b.set(aurum.biomes.get_all_group("forest")), b.set(aurum.biomes.get_all_group("dark")))),
	light_max = 9,
}
