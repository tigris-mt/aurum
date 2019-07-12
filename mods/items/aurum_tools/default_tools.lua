local S = minetest.get_translator()

local function handdig(time)
	return {times = {[3] = time}, uses = 0, maxlevel = 0}
end

local handdef = aurum.tools.register("aurum_tools:hand", {
	description = S"Hand",
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
			dig_snap = handdig(0.5),
		},
		damage_groups = {
			impact = 1,
		},
	},

	groups = {not_in_creative_inventory = 1},

	_enchant_levels = 2,
	_enchants = {"hand"},
})

-- Register the standard hand with the same def as our hand.
minetest.register_tool(":", handdef)

local function register(type, name, texture, def)
	local odef = {
		sound = aurum.sounds.tool(),
		inventory_image = ("%s^aurum_tools_%s.png^[makealpha:255,0,255"):format(texture, type),
		_enchants = {type},
	}

	-- Make it look like we're digging.
	if type == "shovel" then
		odef.wield_image = ("(%s)^[transformR90"):format(odef.inventory_image)
	end

	-- Show stone items in doc immediately.
	if name == "stone" then
		def._doc_items_hidden = false
	end

	aurum.tools.register("aurum_tools:" .. type .. "_" .. name, table.combine(odef, def, {
		groups = table.combine({["tool_" .. type] = 1}, def.groups or {}),
	}))
end

-- Pickaxes

register("pickaxe", "stone", "aurum_base_stone.png", {
	description = S"Stone Pickaxe",
	_enchant_levels = 1,
	tool_capabilities = {
		full_punch_interval = 1.3,
		groupcaps = {
			dig_pick = {
				times = {
					[2] = 2,
					[3] = 1,
				},
				uses = 20,
				maxlevel = 0,
			},
		},
		damage_groups = {
			pierce = 3,
		},
	},
})

-- Shovels

register("shovel", "stone", "aurum_base_stone.png", {
	description = S"Stone Shovel",
	_enchant_levels = 1,
	tool_capabilities = {
		full_punch_interval = 1.4,
		groupcaps = {
			dig_dig = {
				times = {
					[1] = 1.8,
					[2] = 1.2,
					[3] = 0.5,
				},
				uses = 20,
				maxlevel = 0,
			},
		},
		damage_groups = {
			pierce = 1,
			blade = 1,
		},
	},
})

-- Machetes

register("machete", "stone", "aurum_base_stone.png", {
	description = S"Stone Machete",
	_enchant_levels = 1,
	tool_capabilities = {
		full_punch_interval = 1.2,
		groupcaps = {
			dig_chop = {
				times = {
					[1] = 3,
					[2] = 2,
					[3] = 1.3,
				},
				uses = 20,
				maxlevel = 0,
			},
			dig_snap = {
				times = {
					[1] = 2.8,
					[2] = 1.4,
					[3] = 0.4,
				},
				uses = 20,
				maxlevel = 0,
			},
		},
		damage_groups = {
			blade = 3,
		},
	},
})

-- Hammers

register("hammer", "stone", "aurum_base_stone.png", {
	description = S"Stone Hammer",
	_enchant_levels = 1,
	tool_capabilities = {
		full_punch_interval = 1.8,
		groupcaps = {
			dig_hammer = {
				times = {
					[1] = 3,
					[2] = 2,
					[3] = 1,
				},
				uses = 20,
				maxlevel = 0,
			},
		},
		damage_groups = {
			impact = 6,
		},
	},
})
