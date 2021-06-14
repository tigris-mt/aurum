local S = aurum.get_translator()
local hand_groups = {
	times = {
		[1] = 3,
		[2] = 2,
		[3] = 1,
	},
	uses = 0,
	maxlevel = 3,
}

aurum.tools.register("aurum_equip:shaper_gloves", {
	description = S"Shaper Gloves",
	_doc_items_longdesc = S"Powerful magic tools that wrap the hand and provide the ability to shape the very earth itself.",

	inventory_image = "aurum_equip_shaper_gloves.png",
	wield_image = "aurum_equip_shaper_gloves.png",
	wield_scale = vector.new(1, 1, 2.5),
	tool_capabilities = {
		full_punch_interval = 1,
		groupcaps = {
			dig_handle = hand_groups,
			dig_long_handle = hand_groups,
			dig_pick = hand_groups,
			dig_chop = hand_groups,
			dig_dig = hand_groups,
			dig_snap = hand_groups,
		},
		damage_groups = {
			impact = 6,
			pierce = 3,
		},
	},

	_enchant_levels = 12,
	_enchants = {"hand", "tool", "armor", "gloves"},

	_eqtype = "hands",
	on_use = gequip.on_use,
	_eqdef = {
		armor = {
			burn = 0.75,
			chill = 0.75,
			psyche = 0.75,
		},
		durability = 100,
	},

	groups = {equipment = 1, tool_hand = 1, tool = 1},

	_no_enchanted_inventory_image = true,
})

minetest.register_craft{
	output = "aurum_equip:shaper_gloves",
	recipe = {
		{"aurum_fear:aurum", "aurum_mobs_animals:golden_egg", "aurum_fear:loom"},
		{"aurum_fear:ultimus", "aurum_equip:gold_gloves", "aurum_fear:primus"},
	},
}
