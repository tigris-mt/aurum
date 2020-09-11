local S = minetest.get_translator()

aurum.mobs.register("aurum_mobs_monsters:psyche_flare", {
	description = S"Psyche Flare",
	longdesc = S"The sterotypical summoner's tool.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_monsters_psyche_flare.png"},
		visual_size = {x = 1, y = 1},

		hp_max = 25,
	},

	pathfinder = aurum.mobs.DEFAULT_FLY_PATHFINDER,

	initial_data = {
		habitat_nodes = {"group:stone", "group:clay", "group:clay_brick", "group:wood", "group:sand", "aurum_base:gravel"},
		xmana = 15,
		movement = "fly",
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {psyche = 5},
			distance = 32,
			speed = 1,
			fire_projectile = "aurum_mobs_monsters:loom_flare_shot",
			type = "ranged",
		}),
		base_speed = 3,
	},

	armor_groups = {psyche = 20, burn = 70, chill = 70},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
		},

		global_events = {
			punch = "fight",
			interact = "",
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
					"aurum_mobs:find_parent",
					"aurum_mobs:find_habitat",
					"aurum_mobs:find_random",
				},

				events = {
					found_prey = "fight",
					found_parent = "go",
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
				},
				events = {
					lost_sight = "roam",
					lost = "roam",
					reached = "",
				},
			},
		},
	},
})

aurum.mobs.register_spawn{
	mob = "aurum_mobs_monsters:psyche_flare",
	chance = 25 ^ 3,
	biomes = {"ultimus"},
}

