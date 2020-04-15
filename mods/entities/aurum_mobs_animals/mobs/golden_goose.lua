local S = minetest.get_translator()

aurum.mobs.register("aurum_mobs_animals:golden_goose", {
	description = S"Golden Goose",
	longdesc = S"The goose that laid the golden egg. In legend, they were the messengers of Hyperion.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_animals_golden_goose.png"},
		visual_size = {x = 1.5, y = 1},

		hp_max = 25,
	},

	initial_data = {
		habitat_nodes = {"aurum_base:aether_shell", "aurum_base:aether_skin", "aurum_base:aether_flesh"},
		drops = {"aurum_animals:raw_meat 3", "aurum_animals:bone 3", "aurum_ore:gold_ingot 2"},
		xmana = 16,
		pathfinder = aurum.mobs.DEFAULT_FLY_PATHFINDER,
		movement = "fly",
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {pierce = 5, impact = 10},
		}),
		base_speed = 3,
	},

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

			go_fight = {
				actions = {
					"aurum_mobs:adrenaline",
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
	mob = "aurum_mobs_animals:golden_goose",
	chance = 22 ^ 3,
	biomes = aurum.biomes.get_all_group("aurum:aether", {"base"}),
}
