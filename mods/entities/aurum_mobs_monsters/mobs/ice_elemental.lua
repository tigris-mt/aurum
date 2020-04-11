local S = minetest.get_translator()

aurum.mobs.register("aurum_mobs_monsters:ice_elemental", {
	description = S"Ice Elemental",
	longdesc = S"Stray energies wrapped into a frozen, shambling being. It dissolves in sunlight.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_monsters_ice_elemental.png"},
		visual_size = {x = 1, y = 2},

		hp_max = 40,
	},

	initial_data = {
		habitat_nodes = {"group:snow", "group:ice"},
		xmana = 20,
		pathfinder = b.t.combine(aurum.mobs.DEFAULT_PATHFINDER, {
			clearance_height = 2,
			drop_height = -1,
		}),
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {blade = 6, chill = 8},
		}),
		base_speed = 1.5,
	},

	armor_groups = {chill = 0, burn = 130, pierce = 50, blade = 50, psyche = 110},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
			"aurum_mobs:sunlight_damage",
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

			stand = {
				actions = {
					"aurum_mobs:find_prey",
					"aurum_mobs:timeout",
				},

				events = {
					found_prey = "go_fight",
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
	mob = "aurum_mobs_monsters:ice_elemental",
	chance = 19 ^ 3,
	biomes = aurum.biomes.get_all_group("frozen"),
	light_max = 9,
}
