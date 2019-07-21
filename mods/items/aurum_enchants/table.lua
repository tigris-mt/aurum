local S = minetest.get_translator()

local gold = minetest.registered_nodes["aurum_ore:gold_block"].tiles[1]

minetest.register_node("aurum_enchants:table", {
	description = S"Enchanting Table",
	tiles = {gold .. "^aurum_enchants_table_top.png", gold, gold .. "^aurum_enchants_table_side.png"},
	paramtype = "light",
	light_source = 10,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	groups = {dig_pick = 2},
})

minetest.register_craft{
	output = "aurum_enchants:table",
	recipe = {
		{"aurum_ore:mana_bean", "aurum_ore:gold_ingot", "aurum_ore:mana_bean"},
		{"aurum_base:sticky_stick", "aurum_ore:gold_block", "aurum_base:sticky_stick"},
		{"aurum_ore:bronze_ingot", "aurum_ore:gold_ingot", "aurum_ore:bronze_ingot"},
	},
}
