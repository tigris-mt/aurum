local S = aurum.get_translator()

aurum.mobs.register("aurum_mobs_animals:angler", {
	description = S"Angler",
	longdesc = S"A uniquely Aurum creature, this fish inhabits cold waters in that realm.\nSpecimens that live underground are uniquely powerful and hostile.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_animals_angler.png"},
		visual_size = {x = 1, y = 1},

		hp_max = 15,
	},

	pathfinder = aurum.mobs.DEFAULT_SWIM_PATHFINDER,

	initial_data = {
		habitat_nodes = {"group:water"},
		drops = {"aurum_animals:raw_meat 2", "aurum_animals:bone 2"},
		xmana = 6,
		movement = "swim",
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {pierce = 8},
		}),
		base_speed = 2,
	},

	armor_groups = {psyche = 50, chill = 50, poison = 50},

	entity_def = {
		_mob_init = function(self)
			if self.object:get_pos().y < -50 then
				self._data.properties = {hp_max = 30, textures = {"aurum_mobs_animals_angler_cave.png"}}
				self._data.hp = 30
				self._data.gemai.xmana = 14
				self._data.gemai.attack = b.t.combine(aurum.mobs.initial_data.attack, {
					damage = {pierce = 16},
				})
			else
				self._data.gemai.hunt_prey = {""}
			end
		end,
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
	mob = "aurum_mobs_animals:angler",
	chance = 20 ^ 3,
	-- Aurum biomes with heat <= 50.
	biomes = b.set.to_array(b.set._and(b.set(aurum.biomes.find(function(def) return def.heat_point <= 50 end)), b.set(aurum.biomes.get_all_group("aurum:aurum")))),
}
