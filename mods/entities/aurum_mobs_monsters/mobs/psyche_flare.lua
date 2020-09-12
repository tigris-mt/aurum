local S = minetest.get_translator()

gprojectiles.register("aurum_mobs_monsters:psyche_flare_shot", {
	initial_properties = {
		collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
		visual = "sprite",
		textures = {"aurum_mobs_monsters_loom_flare_shot.png"},
	},
	on_collide = function(self, thing)
		if thing.type == "object" then
			local rt = b.ref_to_table(thing.ref)
			if rt and (rt.name == "aurum_mobs_monsters:psyche_flare" or (self.data.parent and b.ref_table_equal(rt, self.data.parent))) then
				-- No effect, pass through.
			else
				aurum.mobs.helper_do_attack(self.object, self.data.attack, thing.ref)
				self:cancel()
			end
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
		xmana = 0,
		movement = "fly",
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {psyche = 5},
			distance = 32,
			speed = 1,
			fire_projectile = "aurum_mobs_monsters:psyche_flare_shot",
			type = "ranged",
		}),
		base_speed = 3,
		regen_rate = -1 / 5,
	},

	armor_groups = {psyche = 20, burn = 70, chill = 70},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
			"aurum_mobs:regen",
		},

		global_events = {
			punch = "fight",
			interact = "",
			lost = "roam",
			stuck = "roam",
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
					"aurum_mobs:find_parent",
					"aurum_mobs:find_habitat",
					"aurum_mobs:find_random",
				},

				events = {
					herd_alerted = "fight",
					found_parent = "go",
					found_habitat = "go",
					found_random = "go",
				},
			},

			go = {
				actions = {
					"aurum_mobs:go",
				},
				events = {
					herd_alerted = "fight",
					reached = "roam",
				},
			},

			fight = {
				actions = {
					"aurum_mobs:go",
					"aurum_mobs:alert_herd",
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
