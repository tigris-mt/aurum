local S = aurum.get_translator()

aurum.mobs.register("aurum_npcs:summoner", {
	description = S"Summoner",
	herd = "aurum:servitors",
	longdesc = S"One of the servitors, still performing the will of a titan long since departed.",

	box = {-0.35, -0.35, -0.35, 0.35, 0.85, 0.35},
	initial_properties = {
		visual = "sprite",
		textures = {"aurum_npcs_summoner.png"},
		visual_size = {x = 1, y = 2},

		hp_max = 50,
	},

	initial_data = {
		habitat_nodes = {"group:clay_brick", "group:clay", "group:soil"},
		xmana = 15,
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {impact = 3},
		}),
		summon = b.t.combine(aurum.mobs.initial_data.summon, {
			mob = "aurum_mobs_monsters:psyche_flare",
			time = 15,
		}),
	},

	entity_def = {
		_mob_init = function(self)
			self._data.gemai.drops = {b.t.choice{
				aurum.magic.new_spell_scroll("summon_avatar", 1):to_string(),
				aurum.magic.new_spell_scroll("summon_psyche_flare", math.random(1, 3)):to_string(),
				aurum.rods.set_item(ItemStack("aurum_rods:rod"), {
					spell = "summon_psyche_flare",
					level = math.random(1, 3),
				}):to_string(),
			}}
		end,
	},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
			"aurum_npcs:summon",
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
					"aurum_mobs:find_habitat",
					"aurum_mobs:find_prey",
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
					"aurum_mobs:timeout",
					"aurum_mobs:find_prey",
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
					"aurum_mobs:alert_herd",
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

aurum.mobs.register_spawn{
	mob = "aurum_npcs:summoner",
	chance = 25 ^ 3,
	biomes = {"ultimus"},
}
