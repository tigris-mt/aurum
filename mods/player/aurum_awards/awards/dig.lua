local S = minetest.get_translator()

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


