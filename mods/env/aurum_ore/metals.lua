local S = minetest.get_translator()

aurum.ore.register("aurum_ore:copper", {
	description = S"Copper",
	texture = "aurum_ore_white.png^[colorize:#b87333:255^aurum_ore_bumps.png",
	level = 0, depth = 10,
	rarity = 9, num = 6, size = 3,
	growths = {-200, -400},
})

aurum.ore.register("aurum_ore:tin", {
	description = S"Tin",
	texture = "aurum_ore_white.png^[colorize:#d3d4d5:255^aurum_ore_bumps.png",
	level = 1, depth = -100,
	rarity = 11, num = 6, size = 3,
	growths = {-300, -600},
})

aurum.ore.register("aurum_ore:bronze", {
	description = S"Bronze",
	texture = "aurum_ore_white.png^[colorize:#9c5221:255^aurum_ore_bumps.png",
	level = 1,
	ore = false,
})

minetest.register_craft{
	output = "aurum_ore:bronze_ingot 9",
	recipe = {
		{"aurum_ore:copper_ingot", "aurum_ore:copper_ingot", "aurum_ore:copper_ingot"},
		{"aurum_ore:copper_ingot", "aurum_ore:tin_ingot", "aurum_ore:copper_ingot"},
		{"aurum_ore:copper_ingot", "aurum_ore:copper_ingot", "aurum_ore:copper_ingot"},
	},
}

aurum.ore.register("aurum_ore:iron", {
	description = S"Iron",
	texture = "aurum_ore_white.png^[colorize:#522617:255^aurum_ore_bumps.png",
	level = 1, depth = -150,
	rarity = 11, num = 5, size = 4,
	growths = {-400, -600},
})

aurum.ore.register("aurum_ore:gold", {
	description = S"Gold",
	texture = "aurum_ore_white.png^[colorize:#ffc300:255^aurum_ore_bumps.png",
	level = 2, depth = -250,
	rarity = 12, num = 3, size = 3,
	growths = {-600, -700},
})
