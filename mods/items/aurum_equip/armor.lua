local S = minetest.get_translator()

function aurum.equip.register_armor(name, def)
	def = b.t.combine({
		description = "?",
		texture = "aurum_base_stone.png",
		enchants = {},
		enchant_levels = 0,
		armor = {},
		slot = "?",
		recipe = nil,
		durability = 1,
	}, def)

	aurum.tools.register(name, {
		description = def.description,
		inventory_image = def.texture,
		sound = aurum.sounds.tool(),

		_enchants = def.enchants,
		_enchant_levels = def.enchant_levels,
		_eqtype = def.slot,
		on_use = gequip.on_use,
		_eqdef = {
			armor = def.armor,
			durability = def.durability,
		},

		groups = {equipment = 1},
	})

	if def.recipe then
		minetest.register_craft{
			output = name,
			recipe = def.recipe,
		}
	end
end

function aurum.equip.register_armor_set(prefix, def)
	def = b.t.combine({
		description = "?",
		material = "aurum_base:stone",
		texture = "aurum_base_stone.png",

		-- Enchant levels for items.
		enchant_levels = 0,

		-- Additional enchantment categories.
		enchants = {},

		-- Base armor levels (in fraction of damage blocked).
		armor = {},

		-- Durability multiplier.
		durability = 1,
	}, def)

	aurum.equip.register_armor(prefix .. "_boots", {
		description = S("@1 Boots", def.description),
		texture = ("%s^aurum_equip_boots.png^[makealpha:255,0,255"):format(def.texture),
		enchants = b.t.icombine({"armor", "boots"}, def.enchants),
		enchant_levels = def.enchant_levels,
		armor = b.t.map(def.armor, function(n) return 1 - (1 - n) * 0.75 end),
		slot = "feet",
		durability = def.durability,
		recipe = {
			{def.material, "", def.material},
			{def.material, "", def.material},
		},
	})

	aurum.equip.register_armor(prefix .. "_pants", {
		description = S("@1 Pants", def.description),
		texture = ("%s^aurum_equip_pants.png^[makealpha:255,0,255"):format(def.texture),
		enchants = b.t.icombine({"armor", "pants"}, def.enchants),
		enchant_levels = def.enchant_levels,
		armor = def.armor,
		slot = "legs",
		durability = def.durability,
		recipe = {
			{def.material, def.material, def.material},
			{def.material, "", def.material},
			{def.material, "", def.material},
		},
	})

	aurum.equip.register_armor(prefix .. "_hauberk", {
		description = S("@1 Hauberk", def.description),
		texture = ("%s^aurum_equip_hauberk.png^[makealpha:255,0,255"):format(def.texture),
		enchants = b.t.icombine({"armor", "hauberk"}, def.enchants),
		enchant_levels = def.enchant_levels,
		armor = def.armor,
		slot = "chest",
		durability = def.durability,
		recipe = {
			{def.material, "", def.material},
			{def.material, def.material, def.material},
			{def.material, def.material, def.material},
		},
	})

	aurum.equip.register_armor(prefix .. "_helmet", {
		description = S("@1 Helmet", def.description),
		texture = ("%s^aurum_equip_helmet.png^[makealpha:255,0,255"):format(def.texture),
		enchants = b.t.icombine({"armor", "helmet"}, def.enchants),
		enchant_levels = def.enchant_levels,
		armor = b.t.map(def.armor, function(n) return 1 - (1 - n) * 0.75 end),
		slot = "head",
		durability = def.durability,
		recipe = {
			{def.material, def.material, def.material},
			{def.material, "", def.material},
		},
	})
end

aurum.equip.register_armor_set("aurum_equip:copper", {
	description = S"Copper",
	material = "aurum_ore:copper_ingot",
	enchant_levels = 2,
	texture = aurum.ore.ores["aurum_ore:copper"].texture,

	durability = 50,

	armor = {
		blade = 0.9,
		pierce = 0.9,
		impact = 0.98,
	},
})

aurum.equip.register_armor_set("aurum_equip:bronze", {
	description = S"Bronze",
	material = "aurum_ore:bronze_ingot",
	enchant_levels = 4,
	texture = aurum.ore.ores["aurum_ore:bronze"].texture,

	durability = 75,

	armor = {
		blade = 0.85,
		pierce = 0.85,
		impact = 0.95,
	},
})

aurum.equip.register_armor_set("aurum_equip:iron", {
	description = S"Iron",
	material = "aurum_ore:iron_ingot",
	enchant_levels = 6,
	texture = aurum.ore.ores["aurum_ore:iron"].texture,

	durability = 100,

	armor = {
		blade = 0.8,
		pierce = 0.8,
		impact = 0.9,
	},
})

aurum.equip.register_armor_set("aurum_equip:gold", {
	description = S"Gold",
	material = "aurum_ore:gold_ingot",
	enchant_levels = 12,
	texture = aurum.ore.ores["aurum_ore:gold"].texture,

	durability = 50,

	armor = {
		blade = 0.7,
		pierce = 0.7,
		impact = 0.8,
	},
})
