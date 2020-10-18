local S = minetest.get_translator()

gemai.register_action("aurum_npcs:avatar_caligula_attack_modify", function(self)
	local nearby = math.max(1, aurum.mobs.helper_nearby_players(self))
	self.data.regen_rate = nearby * 10
end)

aurum.mobs.register("aurum_npcs:avatar_caligula", {
	description = S"Avatar of Caligula",
	herd = "aurum:servitors",
	longdesc = S"Lord of the Dead City.",

	box = {-0.35, -0.35, -0.35, 0.35, 0.85, 0.35},

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_npcs_avatar_caligula.png"},
		visual_size = {x = 1, y = 2},

		hp_max = 100,
	},

	pathfinder = aurum.mobs.DEFAULT_FLY_PATHFINDER,

	initial_data = {
		habitat_nodes = {"group:dirt", "group:stone", "group:clay", "group:clay_brick"},
		xmana = 100,
		movement = "fly",
		hunt_prey = {"player"},
		regen_rate = 1,
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {chill = 10, psyche = 10, impact = 10},
		}),
		base_speed = 1,
	},

	entity_def = {
		_mob_init = function(self)
			self._data.gemai.drops = {"aurum_fear:ultimus " .. math.random(1, 3)}
		end,
	},

	armor_groups = {chill = 0, psyche = 0},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
			"aurum_mobs:regen",
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
					"aurum_mobs:teleport",
				},
				events = {
					found_prey = "go_fight",
					reached = "roam",
				},
			},

			go_fight = {
				actions = {
					"aurum_mobs:teleport",
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
