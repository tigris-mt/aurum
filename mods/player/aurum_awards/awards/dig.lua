local S = aurum.get_translator()

awards.register_award("aurum_awards:dig_all", {
	title = S"Fledgling Sculptor",
	description = S"Dig 250 nodes.",
	icon = minetest.registered_items["aurum_tools:iron_pickaxe"].inventory_image,
	difficulty = 1,
	trigger = {
		type = "dig",
		target = 250,
	},
})

local function ic(n)
	local def = minetest.registered_items[n]
	return minetest.inventorycube(def.tiles[1], def.tiles[1], def.tiles[1])
end

awards.register_award("aurum_awards:copper", {
	title = S"Copper Age",
	description = S"Dig copper.",
	icon = ic"aurum_ore:copper_ore",
	difficulty = 10,
	trigger = {
		type = "dig",
		node = "aurum_ore:copper_ore",
		target = 1,
	},
})

awards.register_award("aurum_awards:tin", {
	title = S"Tin Age",
	description = S"Dig tin.",
	requires = {"aurum_awards:copper"},
	icon = ic"aurum_ore:tin_ore",
	difficulty = 20,
	trigger = {
		type = "dig",
		node = "aurum_ore:tin_ore",
		target = 1,
	},
})

awards.register_award("aurum_awards:iron", {
	title = S"Iron Age",
	description = S"Dig iron.",
	requires = {"aurum_awards:tin"},
	icon = ic"aurum_ore:iron_ore",
	difficulty = 40,
	trigger = {
		type = "dig",
		node = "aurum_ore:iron_ore",
		target = 1,
	},
})

awards.register_award("aurum_awards:gold", {
	title = S"Era of Aurum",
	description = S"Dig gold.",
	requires = {"aurum_awards:iron"},
	icon = ic"aurum_ore:gold_ore",
	difficulty = 50,
	trigger = {
		type = "dig",
		node = "aurum_ore:gold_ore",
		target = 1,
	},
})
