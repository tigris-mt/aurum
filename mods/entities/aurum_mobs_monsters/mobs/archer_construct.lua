local S = aurum.get_translator()

gprojectiles.register("aurum_mobs_monsters:archer_construct_shot", {
	initial_properties = {
		collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
		visual = "sprite",
		textures = {"aurum_mobs_monsters_archer_construct_shot.png"},
	},
	on_collide = function(self, thing)
		if thing.type == "object" then
			aurum.mobs.helper_do_attack(self.object, self.data.attack, thing.ref)
			self:cancel()
		elseif thing.type == "node" then
			local nn = minetest.get_node(thing.under).name
			local def = minetest.registered_items[nn]
			if def then
				if def.walkable or (def._liquidtype or "none") ~= "none" then
					self:cancel()
				end
			end
		end
	end,
})

aurum.mobs.register("aurum_mobs_monsters:archer_construct", {
	description = S"Archer Construct",
	longdesc = S"A wandering, half-living archer.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_monsters_archer_construct.png"},
		visual_size = {x = 1, y = 1},

		hp_max = 25,
	},

	initial_data = {
		habitat_nodes = {"group:stone", "aurum_base:regret"},
		xmana = 6,
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {pierce = 8},
			distance = 32,
			speed = 1,
			fire_projectile = "aurum_mobs_monsters:archer_construct_shot",
			type = "ranged",
		}),
		base_speed = 1.5,
	},

	armor_groups = {chill = 70, psyche = 20, drown = 0},

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
					found_prey = "fight",
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
					found_prey = "fight",
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
	mob = "aurum_mobs_monsters:archer_construct",
	chance = 20 ^ 3,
	biomes = aurum.biomes.get_all_group("all", {"under"}),
	light_max = 9,
}
