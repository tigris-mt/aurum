local S = minetest.get_translator()

function aurum.equip.register_armor(name, def)
	def = table.combine({
		description = "?",
		texture = "aurum_base_stone.png",
		enchants = {},
		enchant_levels = 0,
		armor = {},
		slot = "?",
		recipe = nil,
	}, def)

	aurum.tools.register(name, {
		description = def.description,
		inventory_image = def.texture,
		sound = aurum.sounds.tool(),

		_enchants = def.enchants,
		_enchant_levels = def.enchant_levels,
		_eqtype = def.slot,
		_eqdef = {
			armor = def.armor,
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
	def = table.combine({
		description = "?",
		material = "aurum_base:stone",
		texture = "aurum_base_stone.png",

		-- Enchant levels for items.
		enchant_levels = 0,

		-- Additional enchantment categories.
		enchants = {},

		-- Base armor levels (in fraction of damage blocked).
		armor = {},
	}, def)

	aurum.equip.register_armor(prefix .. "_boots", {
		description = S("@1 Boots", def.description),
		texture = ("%s^aurum_equip_boots.png^[makealpha:255,0,255"):format(def.texture),
		enchants = table.icombine({"armor", "boots"}, def.enchants),
		enchant_levels = def.enchant_levels,
		armor = table.map(def.armor, function(n) return 1 - (1 - n) * 0.75 end),
		slot = "feet",
		recipe = {
			{def.material, "", def.material},
			{def.material, "", def.material},
		},
	})
end

aurum.equip.register_armor_set("aurum_equip:copper", {
	description = S"Copper",
	material = "aurum_ore:copper_ingot",
	enchant_levels = 2,
	texture = aurum.ore.ores["aurum_ore:copper"].texture,

	armor = {
		blade = 0.9,
		pierce = 0.9,
		impact = 0.98,
	},
})
