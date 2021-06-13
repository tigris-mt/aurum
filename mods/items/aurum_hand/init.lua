aurum_hand = {}

local function hand_dig(time)
	return {times = {[3] = time}, uses = 0, maxlevel = 0}
end

aurum_hand.def = {
	wield_image = "wieldhand.png",
	wield_scale = vector.new(1, 1, 2.5),
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			dig_handle = {
				times = {
					[1] = 2,
					[2] = 1.5,
					[3] = 0.5,
				},
				uses = 0,
				maxlevel = 3,
			},
			dig_long_handle = {
				times = {
					[1] = 15,
					[2] = 10,
					[3] = 5,
				},
				uses = 0,
				maxlevel = 3,
			},
			-- The hand can dig the lowest levels of all other groups, but slowly.
			dig_pick = hand_dig(6),
			dig_chop = hand_dig(3),
			dig_dig = hand_dig(1.5),
			dig_snap = hand_dig(0.5),
		},
		damage_groups = {
			impact = 1,
		},
	},

	groups = {not_in_creative_inventory = 1, tool_hand = 1, tool = 1},

	_enchant_levels = 2,
	_enchants = {"hand"},
}

minetest.register_tool(":", b.t.combine(aurum_hand.def, {
	type = "none",
}))

minetest.register_on_joinplayer(function(player)
	player:get_inventory():set_size("hand", 1)
end)
