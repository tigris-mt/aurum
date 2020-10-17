local S = minetest.get_translator()

aurum.mobs.register("aurum_npcs:avatar_decadence", {
	description = S"Avatar of Mr. Decadence",
	herd = "aurum:servitors",
	longdesc = S"The administrator of the Loom.",

	box = {-0.35, -0.35, -0.35, 0.35, 0.85, 0.35},

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_npcs_avatar_decadence.png"},
		visual_size = {x = 1, y = 2},

		hp_max = 100,
	},

	pathfinder = aurum.mobs.DEFAULT_FLY_PATHFINDER,

	initial_data = {
		habitat_nodes = {"group:dirt", "group:stone", "group:clay"},
		xmana = 100,
		movement = "fly",
		hunt_prey = {"player"},
		regen_rate = 1,
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {pierce = 5, psyche = 5},
		}),
		base_speed = 3,
		summon = b.t.combine(aurum.mobs.initial_data.summon, {
			mob = "aurum_mobs_monsters:psyche_flare",
			time = 5,
		}),
	},

	entity_def = {
		_mob_init = function(self)
			self._data.gemai.drops = {"aurum_fear:loom " .. math.random(1, 3)}
		end,
	},

	armor_groups = {psyche = 20},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
			"aurum_mobs:regen",
			"aurum_npcs:summon",
		},

		global_events = {
			punch = "go_fight",
			interact = "",
			herd_alerted = "go_fight",
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
					found_prey = "go_fight",
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
					found_prey = "go_fight",
					reached = "roam",
				},
			},

			go_fight = {
				actions = {
					"aurum_mobs:go",
					"aurum_mobs:alert_herd",
					"aurum_mobs:timeout",
				},
				events = {
					reached = "fight",
				},
			},

			fight = {
				actions = {
					"aurum_mobs:adrenaline",
					"aurum_mobs:alert_herd",
					"aurum_mobs:attack",
				},
				events = {
					noreach = "go_fight",
				},
			},
		},
	},
})

