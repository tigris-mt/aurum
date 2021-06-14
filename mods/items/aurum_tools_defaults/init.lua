local S = aurum.get_translator()

aurum.tools.register("aurum_tools:hand", b.t.combine(aurum_hand.def, {
	description = S"Hand",
	_doc_items_longdesc = S"Tools were invented by the primates to surpass the limits of their own limbs, but your hand is not useless on its own. It can dig many nodes with no enhancements at all.",
}))

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

	local tn = "aurum_tools:" .. name .. "_" .. type

	aurum.tools.register(tn, b.t.combine(odef, def, {
		groups = b.t.combine({["tool_" .. type] = 1, tool = 1}, def.groups or {}),
	}))

	minetest.register_craft{
		output = tn,
		recipe = def.recipe,
	}
end

local variants = {
	stone = {
		desc = "Stone",
		texture = "aurum_base_stone.png",
		level = 0,
		enchant_levels = 1,
		material = "aurum_base:stone",
	},
	copper = {
		desc = "Copper",
		texture = aurum.ore.ores["aurum_ore:copper"].texture,
		level = 1,
		enchant_levels = 2,
		material = "aurum_ore:copper_ingot",
	},
	bronze = {
		desc = "Bronze",
		texture = aurum.ore.ores["aurum_ore:bronze"].texture,
		level = 1.5,
		enchant_levels = 4,
		material = "aurum_ore:bronze_ingot",
	},
	iron = {
		desc = "Iron",
		texture = aurum.ore.ores["aurum_ore:iron"].texture,
		level = 2,
		enchant_levels = 6,
		material = "aurum_ore:iron_ingot",
	},
	gold = {
		desc = "Gold",
		texture = aurum.ore.ores["aurum_ore:gold"].texture,
		level = 3,
		enchant_levels = 12,
		durability = 0.15,
		material = "aurum_ore:gold_ingot",
	},
}

for variant,vdef in pairs(variants) do
	local function dig(a, b, c)
		return {
			times = {
				[1] = a - vdef.level / 15,
				[2] = b - vdef.level / 15,
				[3] = c - vdef.level / 15,
			},
			uses = 20 * math.ceil(math.max(1, vdef.level) / 2) * (vdef.durability or 1),
			maxlevel = math.floor(vdef.level),
		}
	end

	register("pickaxe", variant, vdef.texture, {
		description = S(vdef.desc .. " Pickaxe"),
		_doc_items_longdesc = S"A tool for extracting stone, metal, and other hard substances.",
		_enchant_levels = vdef.enchant_levels,
		_enchants = {"tool", "pickaxe"},
		tool_capabilities = {
			full_punch_interval = 1.3 - vdef.level / 15,
			groupcaps = {
				dig_pick = dig(3, 2, 1),
			},
			damage_groups = {
				pierce = 3 + math.floor(vdef.level),
			},
		},
		recipe = {
			{vdef.material, vdef.material, vdef.material},
			{"", "aurum_base:sticky_stick", ""},
			{"", "aurum_base:stick", ""},
		},
	})

	register("shovel", variant, vdef.texture, {
		description = S(vdef.desc .. " Shovel"),
		_doc_items_longdesc = S"Used for collecting soft or crumbling material such as dirt and gravel.",
		_enchant_levels = vdef.enchant_levels,
		_enchants = {"tool", "shovel"},
		tool_capabilities = {
			full_punch_interval = 1.4 - vdef.level / 10,
			groupcaps = {
				dig_dig = dig(1.8, 1.2, 0.5),
			},
			damage_groups = {
				pierce = 1,
				blade = 1 + math.floor(vdef.level),
			},
		},
		recipe = {
			{"", vdef.material, ""},
			{"", "aurum_base:sticky_stick", ""},
			{"", "aurum_base:stick", ""},
		},
	})

	register("machete", variant, vdef.texture, {
		description = S(vdef.desc .. " Machete"),
		_doc_items_longdesc = S"A sharp blade to chop down wood and vegetation.",
		_enchant_levels = vdef.enchant_levels,
		_enchants = {"tool", "machete"},
		tool_capabilities = {
			full_punch_interval = 1.2 - vdef.level / 10,
			groupcaps = {
				dig_chop = dig(3, 2, 1.3),
				dig_snap = dig(2.8, 1.4, 0.4),
			},
			damage_groups = {
				blade = 3 + math.floor(vdef.level),
			},
		},
		recipe = {
			{vdef.material, vdef.material, ""},
			{vdef.material, "aurum_base:sticky_stick", ""},
			{"", "aurum_base:stick", ""},
		},
	})

	register("hammer", variant, vdef.texture, {
		description = S(vdef.desc .. " Hammer"),
		_doc_items_longdesc = S"A deadly weapon, built to crush.",
		_enchant_levels = vdef.enchant_levels,
		_enchants = {"tool", "weapon", "hammer"},
		tool_capabilities = {
			full_punch_interval = 1.8 - vdef.level / 10,
			groupcaps = {
				dig_hammer = dig(3, 2, 1),
			},
			damage_groups = {
				impact = 6 + math.floor(vdef.level),
			},
		},
		recipe = {
			{vdef.material, vdef.material, vdef.material},
			{vdef.material, "aurum_base:sticky_stick", vdef.material},
			{"", "aurum_base:stick", ""},
		},
	})
end
