local S = minetest.get_translator()

gprojectiles.register("aurum_mobs_monsters:loom_flare_shot", {
	initial_properties = {
		collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
		visual = "sprite",
		textures = {"aurum_mobs_monsters_loom_flare_shot.png"},
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

aurum.mobs.register("aurum_mobs_monsters:loom_flare", {
	description = S"Loom Flare",
	longdesc = S"An eruption of regret taken the form of an archer.",

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_mobs_monsters_loom_flare.png"},
		visual_size = {x = 1, y = 1},

		hp_max = 50,
	},

	initial_data = {
		habitat_nodes = {"aurum_base:regret"},
		xmana = 10,
		attack = b.t.combine(aurum.mobs.initial_data.attack, {
			damage = {burn = 10},
			distance = 32,
			fire_projectile = "aurum_mobs_monsters:loom_flare_shot",
		}),
	},

	armor_groups = {burn = 50, chill = 120, psyche = 50},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
		},

		global_events = {
			punch = "fight",
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
				},

				events = {
					found_prey = "fight",
				},
			},

			fight = {
				actions = {
					"aurum_mobs:attack",
				},
				events = {
					lost_sight = "roam",
					lost = "roam",
				},
			},
		},
	},
})

aurum.mobs.register_spawn{
	mob = "aurum_mobs_monsters:loom_flare",
	chance = 16 ^ 3,
	biomes = aurum.biomes.get_all_group("aurum:loom"),
}
