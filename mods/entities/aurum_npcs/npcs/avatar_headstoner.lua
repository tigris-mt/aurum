local S = minetest.get_translator()

minetest.register_node("aurum_npcs:headstoner_dirt", {
	description = S"Strange Dirt",
	tiles = {"aurum_farming_fertilizer.png"},
	sounds = aurum.sounds.dirt(),
	groups = {soil = 1, liquid = 1, dig_dig = 2, dig_long_handle = 1},
	liquid_viscosity = 15,

	liquidtype = "source",
	liquid_alternative_flowing = "aurum_npcs:headstoner_dirt",
	liquid_alternative_source = "aurum_npcs:headstoner_dirt",

	liquid_renewable = false,
	liquid_range = 0,
	drowning = 1,
	post_effect_color = {r = 15, g = 21, b = 7, a = 245},

	walkable = false,
	drop = "",
})

minetest.register_abm{
	label = "Headstoner Dirt",
	nodenames = {"aurum_npcs:headstoner_dirt"},
	interval = 2,
	chance = 1,
	catch_up = false,
	action = function(pos)
		minetest.remove_node(pos)
	end,
}

aurum.effects.register("aurum_npcs:headstoner_hit", {
	description = S"Headstoner Hit",
	hidden = true,
	enchant = false,
	max_level = 3,
	apply = function(object, level)
		object:add_player_velocity(vector.multiply(vector.new(10 * (math.random() - 0.5), 5 * math.random() + level, 10 * (math.random() - 0.5)), 4))
		if math.random() < 1/2 then
			-- The Headstoner communicates in small yet somewhat sophisticated wording with neither capitals nor punctuation
			aurum.info_message(object, b.t.choice{
				S"i will bury you in the end",
				S"die",
				S"why have you angered me",
				S"will you care for the world like the old one",
				S"i am what stands between this world and the decay of the two gardens",
				S"do you seek to claim the wings",
				S"you fight but an avatar of me",
				S"if you truly ascend, i will witness",
				S"nothing lasts forever",
				S"not even a titan is eternal",
				S"can you not understand what i am doing for the remnant",
				S"so be it",
				S"this must come to pass",
				S"i will become your glory",
			})
		end
	end,
	cancel = function(object, level)
		local box = b.box.new_radius(vector.round(object:get_pos()), 3)
		for _,pos in ipairs(b.box.poses(box)) do
			if minetest.get_node(pos).name == "air" then
				minetest.set_node(pos, {name = "aurum_npcs:headstoner_dirt"})
			end
		end
	end,
})

-- Become stronger with lower HP.
-- More nearby players greatly increases attack speed.
local function make_attack(hp_ratio, nearby)
	return b.t.combine(aurum.mobs.initial_data.attack, {
		damage = {psyche = (hp_ratio < 0.5) and 15 or 10},
		distance = (hp_ratio < 0.1) and 24 or 12,
		speed = ((hp_ratio < 0.25) and 0.5 or 0.25) * math.max(1, nearby),
		type = "instant",
		effects = {
			["aurum_npcs:headstoner_hit"] = {level = 1 + math.floor(2 - hp_ratio * 2 + 0.5), duration = 1},
			["aurum_effects:poison"] = {level = 1, duration = 4 + (3 - hp_ratio * 3)},
		},
	})
end

gemai.register_action("aurum_npcs:avatar_headstoner_attack_modify", function(self)
	local moves = self.data.attack.moves
	self.data.attack = make_attack(self.entity.object:get_hp() / self.entity.object:get_properties().hp_max, aurum.mobs.helper_nearby_players(self))
	self.data.attack.moves = moves
end)

aurum.mobs.register("aurum_npcs:avatar_headstoner", {
	description = S"Avatar of the Headstoner",
	herd = "aurum:servitors",
	longdesc = S"The gravedigger.",

	box = {-0.35, -0.35, -0.35, 0.35, 0.85, 0.35},

	initial_properties = {
		visual = "sprite",
		textures = {"aurum_npcs_avatar_headstoner.png"},
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
		attack = make_attack(1, 0),
		base_speed = 3,
	},

	entity_def = {
		_mob_init = function(self)
			self._data.gemai.drops = {"aurum_fear:aurum " .. math.random(1, 3)}
		end,
	},

	armor_groups = {burn = 20},

	gemai = {
		global_actions = {
			"aurum_mobs:physics",
			"aurum_mobs:environment",
			"aurum_mobs:regen",
			"aurum_npcs:avatar_headstoner_attack_modify",
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
