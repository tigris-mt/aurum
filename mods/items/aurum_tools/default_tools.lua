local S = minetest.get_translator()

local handdef = aurum.tools.register("aurum_tools:hand", {
	type = "none",
	_doc_items_longdesc = S"Tools were invented by the primates to surpass the limits of their own limbs, but your hand is not useless on its own. It can dig many nodes with no enhancements at all.",
	wield_image = "wieldhand.png",
	wield_scale = vector.new(1, 1, 2.5),
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			dig_hand = {
				times = {
					[1] = 2,
					[2] = 1.5,
					[3] = 0.5,
				},
				uses = 0,
				maxlevel = 3,
			},
			-- The hand can dig the lowest levels of all other groups, but slowly.
			dig_pick = {
				times = {
					[3] = 6
				},
				uses = 0,
				maxlevel = 0,
			},
			dig_chop = {
				times = {
					[3] = 3
				},
				uses = 0,
				maxlevel = 0,
			},
			dig_shovel = {
				times = {
					[3] = 1.5,
				},
				uses = 0,
				maxlevel = 0,
			},
		},
		damage_groups = {
			impact = 1,
		},
	},

	_enchant_levels = 2,
	_enchants = {"hand"},
})

-- Register the standard hand with the same def as our hand.
minetest.register_tool(":", handdef)
