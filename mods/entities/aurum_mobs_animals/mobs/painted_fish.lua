local S = aurum.get_translator()

aurum.mobs.register("aurum_mobs_animals:painted_fish", {
	description = S"Painted Fish",
	longdesc = S"A fantastic fish that loves living in the warmer waters of all Aurum.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_animals_painted_fish.png"},
		visual_size = {x = 1, y = 1},

		hp_max = 15,
	},

	pathfinder = aurum.mobs.DEFAULT_SWIM_PATHFINDER,

	initial_data = {
		habitat_nodes = {"group:water"},
		drops = {"aurum_animals:raw_meat 2", "aurum_animals:bone 2"},
		xmana = 2,
		movement = "swim",
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {pierce = 2},
		}),
		base_speed = 2,
	},

	armor_groups = {psyche = 50, chill = 50, poison = 50},

	entity_def = {
		_mob_init = function(self)
			self._data.properties = {textures = {"aurum_mobs_animals_painted_fish.png^(aurum_mobs_animals_painted_fish_colors.png^[colorize:" .. b.color.tostring(b.t.choice(b.t.keys(b.color.names))) .. ":127)"}}
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
					"aurum_mobs:find_habitat",
					"aurum_mobs:find_random",
				},

				events = {
					found_habitat = "go",
					found_random = "go",
				},
			},

			stand = {
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
	mob = "aurum_mobs_animals:painted_fish",
	chance = 20 ^ 3,
	-- Aurum biomes with heat > 50.
	biomes = b.set.to_array(b.set._and(b.set(aurum.biomes.find(function(def) return def.heat_point > 50 end)), b.set(aurum.biomes.get_all_group("aurum:aurum")))),
}
