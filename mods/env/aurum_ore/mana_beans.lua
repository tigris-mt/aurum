local S = minetest.get_translator()

aurum.ore.register("aurum_ore:mana_beans", {
	description = S"Mana Beans",
	texture = "aurum_ore_white.png^[colorize:#7e00ff:255^aurum_ore_bumps.png",
	level = 0, depth = aurum.WORLD.max.y,
	rarity = 8, num = 3, size = 2,
	growths = {-200, -400},

	ore = "aurum_ore:mana_bean_deposit",
	ore_override = {
		_doc_items_longdesc = S"A small deposit of mana. It is not very pure, but still useful.",
		description = S"Mana Bean Deposit",

		drop = {
			items = {
				{items = {"aurum_ore:mana_bean"}, rarity = 1},
				{items = {"aurum_ore:mana_bean"}, rarity = 2},
				{items = {"aurum_ore:mana_bean 2"}, rarity = 3},
			},
		},

		after_dig_node = function(pos, _, _, player)
			aurum.player.mana_sparks(player, pos, "digging", 1, 2)
		end,
	},

	ingot = false,
	block = false,
	recipes = false,
})

minetest.register_craftitem("aurum_ore:mana_bean", {
	description = S"Mana Bean",
	_doc_items_longdesc = S"An impure nugget of mana. It vibrates slightly when touched and is a powerful fuel.",
	inventory_image = "aurum_ore_mana_bean.png",
	groups = {dye_source = 1, color_violet = 1},
})

minetest.register_craft{
	type = "fuel",
	recipe = "aurum_ore:mana_bean",
	burntime = 8,
}
