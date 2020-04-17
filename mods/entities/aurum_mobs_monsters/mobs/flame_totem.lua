local S = minetest.get_translator()

aurum.mobs.register("aurum_mobs_monsters:flame_totem", {
	description = S"Flame Totem",
	herd = "aurum:servitors",
	longdesc = S"A great guardian, an automaton belonging to the old servitors. In ancient times these proud creations were revered by all. Some say they are an uplifted form of the loom flare.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_monsters_flame_totem.png"},
		visual_size = {x = 1, y = 1},

		hp_max = 50,
	},

	pathfinder = aurum.mobs.DEFAULT_FLY_PATHFINDER,

	initial_data = {
		habitat_nodes = {"aurum_base:aether_shell", "aurum_base:aether_skin", "aurum_base:aether_flesh"},
		xmana = 25,
		movement = "fly",
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {burn = 15},
			distance = 32,
			speed = 1,
			fire_projectile = "aurum_mobs_monsters:loom_flare_shot",
		}),
		base_speed = 3,
	},

	armor_groups = {burn = 50, chill = 120, psyche = 80},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
		},

		global_events = {
			punch = "fight",
			interact = "",
			herd_alerted = "fight",
			lost = "roam",
			stuck = "roam",
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
					found_prey = "fight",
					found_habitat = "go",
					found_random = "go",
				},
			},

			go = {
				actions = {
					"aurum_mobs:find_prey",
					"aurum_mobs:go",
				},
				events = {
					found_prey = "fight",
					reached = "roam",
				},
			},

			fight = {
				actions = {
					"aurum_mobs:go",
					"aurum_mobs:attack",
					"aurum_mobs:alert_herd",
				},
				events = {
					lost_sight = "roam",
					lost = "roam",
					herd_alerted = "",
					reached = "",
				},
			},
		},
	},
})

aurum.mobs.register_spawn{
	mob = "aurum_mobs_monsters:flame_totem",
	chance = 25 ^ 3,
	biomes = aurum.biomes.get_all_group("aurum:aether", {"base"}),
}
