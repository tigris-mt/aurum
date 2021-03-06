local S = aurum.get_translator()

aurum.mobs.register("aurum_mobs_animals:spider", {
	description = S"Spider",
	herd = "aurum:loom",
	longdesc = S"A warped arthropod emerging from the strange machinations of the loom.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_animals_spider.png"},
		visual_size = {x = 1, y = 1},

		hp_max = 14,
	},

	initial_data = {
		habitat_nodes = {"group:clay", "group:stone", "aurum_base:regret", "aurum_base:gravel"},
		drops = {"aurum_animals:raw_meat 1"},
		xmana = 8,
		pathfinder = {
			jump_height = 3,
		},
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {pierce = 2, blade = 2},
			effects = {
				["aurum_effects:poison"] = {level = 1, duration = 2},
			},
		}),
		base_speed = 2.5,
	},

	armor_groups = {pierce = 80, blade = 80, fall = 0, psyche = 50, burn = 80},

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
	mob = "aurum_mobs_animals:spider",
	chance = 19 ^ 3,
	biomes = b.set.to_array(b.set._or(
		b.set(aurum.biomes.get_all_group("aurum:aurum", {"under"})),
		b.set._and(
			b.set(aurum.biomes.get_all_group("aurum:aurum")),
			b.set(aurum.biomes.get_all_group("clay")),
			b.set(aurum.biomes.get_all_group("barren"))
		),
		b.set(aurum.biomes.get_all_group("aurum:loom"))
	)),
	light_max = 9,
}

aurum.mobs.register_spawn{
	mob = "aurum_mobs_animals:spider",
	chance = 19 ^ 3,
	biomes = aurum.biomes.get_all_group("aurum:loom"),
}

