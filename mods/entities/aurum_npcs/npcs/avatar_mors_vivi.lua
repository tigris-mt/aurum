local S = aurum.get_translator()

aurum.effects.register("aurum_npcs:mors_vivi_hit", {
	description = S"Mors Vivi Hit",
	hidden = true,
	enchant = false,
	apply = function(object, level)
		object:set_breath(0)
	end,
	cancel = function(object, level)
		local box = b.box.new_radius(vector.round(object:get_pos()), 10)
		for _,pos in ipairs(b.box.poses(box)) do
			if minetest.get_node(pos).name == "air" then
				minetest.set_node(pos, {name = b.t.choice{
					"aurum_base:water_flowing",
				}})
			end
		end
	end,
})

local function make_attack(nearby)
	return b.t.combine(aurum.mobs.initial_data.attack, {
		damage = {pierce = 10},
		distance = 16,
		speed = (1 / 3) * math.max(1, nearby),
		type = "instant",
		effects = {
			["aurum_npcs:mors_vivi_hit"] = {level = 1, duration = 1},
		},
	})
end

gemai.register_action("aurum_npcs:avatar_mors_vivi_attack_modify", function(self)
	local moves = self.data.attack.moves
	self.data.attack = make_attack(aurum.mobs.helper_nearby_players(self))
	self.data.attack.moves = moves
end)

aurum.mobs.register("aurum_npcs:avatar_mors_vivi", {
	description = S"Avatar of Mors Vivi",
	herd = "aurum:servitors",
	longdesc = S"The cultivator.",

	box = {-0.35, -0.35, -0.35, 0.35, 0.85, 0.35},

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_npcs_avatar_mors_vivi.png"},
		visual_size = {x = 1, y = 2},

		hp_max = 100,
	},

	pathfinder = b.t.combine(aurum.mobs.DEFAULT_FLY_PATHFINDER, {
		node_passable = function(pos, node)
			local def = minetest.registered_nodes[node.name]
			return not def.walkable and (def.damage_per_second or 0) <= 0
		end,
	}),

	initial_data = {
		habitat_nodes = {"group:dirt", "group:stone", "group:clay"},
		xmana = 100,
		movement = "fly",
		hunt_prey = {"player"},
		regen_rate = 5,
		attack = make_attack(0),
		base_speed = 2,
	},

	entity_def = {
		_mob_init = function(self)
			self._data.gemai.drops = {"aurum_fear:primus " .. math.random(1, 3)}
		end,
	},

	armor_groups = {burn = 20, psyche = 20, drown = 0},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
			"aurum_mobs:regen",
			"aurum_npcs:avatar_mors_vivi_attack_modify",
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
