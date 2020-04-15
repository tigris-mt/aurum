local S = minetest.get_translator()

aurum.mobs.register("aurum_npcs:nomad_hermit", {
	description = S"Nomad Hermit",
	herd = "aurum:people",
	longdesc = S"A wandering merchant. They may offer goods for trade.",

	box = {-0.35, -0.35, -0.35, 0.35, 0.85, 0.35},
	initial_properties = {
		visual = "sprite",
		textures = {"aurum_npcs_nomad_hermit.png"},
		visual_size = {x = 1, y = 2},

		hp_max = 50,
	},

	initial_data = {
		habitat_nodes = {"group:wood", "group:soil", "group:clay", "group:sand"},
		drops = {
			items = {
				{
					rarity = 3,
					items = {"aurum_scrolls:scroll"},
				},
				{
					rarity = 3,
					items = {"aurum_scrolls:scroll"},
				},
				{
					rarity = 3,
					items = {"aurum_rods:rod"},
				},
				{
					rarity = 3,
					items = {"aurum_rods:rod"},
				},
			},
		},
		xmana = 8,
		pathfinder = {
			clearance_height = 2,
		},
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {chill = 10, pierce = 5},
			distance = 24,
			speed = 1 / 2,
			fire_projectile = "aurum_npcs:ice_shot",
		}),
	},

	entity_def = {
		_mob_init = function(self)
			local function t(...)
				return (treasurer.select_random_treasures(1, ...)[1] or ItemStack""):to_string()
			end
			self._data.gemai.trades = {
				{
					cost = "aurum_ore:gloria_ingot 2",
					item = t(0, 2),
					has = 4,
					max = 4,
				},
				{
					cost = "aurum_ore:gloria_ingot 4",
					item = t(0, 4),
					has = 2,
					max = 2,
				},
				{
					cost = "aurum_ore:gloria_ingot 6",
					item = t(0, 4, "scroll"),
					has = 2,
					max = 2,
				},
				{
					cost = t(0, 6, "food"),
					item = "aurum_ore:gloria_ingot",
					has = 8,
					max = 8,
				},
			}
		end,
	},

	armor_groups = {psyche = 80},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
			"aurum_npcs:trading_regen",
		},

		global_events = {
			stuck = "roam",
			timeout = "roam",
			punch = "fight",
			lost = "roam",
			interact = "interact",
			herd_alerted = "fight",
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

			["return"] = {
				actions = {
					"aurum_mobs:find_habitat_prio",
					"gemai:always",
				},
				events = {
					found_habitat = "go_once",
					always = "roam",
				},
			},

			stand = {
				actions = {
					"aurum_mobs:timeout",
				},
				events = {
					timeout = "return",
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

			go_once = {
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
					lost_sight = "roam",
					herd_alerted = "",
				},
			},

			interact = {
				actions = {
					"aurum_npcs:trading_begin",
					"gemai:always",
				},
				events = {
					begin_trading = "trading",
					always = "roam",
				},
			},

			trading = {
				flags = b.set{
					"aurum_npcs:trading",
				},
				actions = {
					"aurum_npcs:trading",
				},
				events = {
					traded = "trading",
					end_trading = "roam",
				},
			},
		},
	},
})

aurum.mobs.register_spawn{
	mob = "aurum_npcs:nomad_hermit",
	chance = 25 ^ 3,
	biomes = aurum.biomes.get_all_group("aurum:aurum", {"base"}),
}
