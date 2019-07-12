local S = minetest.get_translator()

local function handdig(time)
	return {times = {[3] = time}, uses = 0, maxlevel = 0}
end

local handdef = aurum.tools.register("aurum_tools:hand", {
	type = "none",
	_doc_items_longdesc = S"Tools were invented by the primates to surpass the limits of their own limbs, but your hand is not useless on its own. It can dig many nodes with no enhancements at all.",
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
			-- The hand can dig the lowest levels of all other groups, but slowly.
			dig_pick = handdig(6),
			dig_chop = handdig(3),
			dig_dig = handdig(1.5),
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
