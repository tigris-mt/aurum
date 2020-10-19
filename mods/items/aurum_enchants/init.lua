local S = aurum.get_translator()
aurum.enchants = {}

b.dofile("armor.lua")
b.dofile("tools.lua")
b.dofile("general.lua")

function aurum.enchants.new_scroll(enchant, level)
	return aurum.scrolls.new{
		type = "enchant",
		name = enchant,
		level = level,
		description = S("Enchantment Scroll: @1 @2", aurum.tools.enchants[enchant].description, level),
	}
end

b.dofile("copying_desk.lua")
b.dofile("table.lua")
