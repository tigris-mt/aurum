local S = minetest.get_translator()
aurum.enchants = {}

aurum.dofile("armor.lua")
aurum.dofile("tools.lua")
aurum.dofile("general.lua")

function aurum.enchants.new_scroll(enchant, level)
	return aurum.scrolls.new{
		type = "enchant",
		name = enchant,
		level = level,
		description = S("Enchantment Scroll: @1 @2", aurum.tools.enchants[enchant].description, level),
	}
end

aurum.dofile("copying_desk.lua")
aurum.dofile("table.lua")
