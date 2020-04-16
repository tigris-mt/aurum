local S = minetest.get_translator()

awards.register_award("aurum_awards:bronze", {
	title = S"Bronze Age",
	description = S"Craft bronze.",
	requires = {"aurum_awards:copper", "aurum_awards:tin"},
	icon = minetest.registered_items["aurum_ore:bronze_ingot"].inventory_image,
	difficulty = 30,
	trigger = {
		type = "craft",
		item = "aurum_ore:bronze_ingot",
		target = 1,
	},
})
