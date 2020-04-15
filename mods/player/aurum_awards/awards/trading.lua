local S = minetest.get_translator()

awards.register_award("aurum_awards:trader", {
	title = S"Stooping to Their Level",
	description = S"Trade with a native.",
	difficulty = 10,
	icon = minetest.registered_items["aurum_ore:gloria_ingot"].inventory_image,
	trigger = {
		type = "trade",
		target = 1,
	},
})

awards.register_award("aurum_awards:advanced_trader", {
	title = S"Marketeer",
	requires = {"aurum_awards:trader"},
	description = S"Trade 150 items.",
	difficulty = 2,
	icon = minetest.registered_items["aurum_ore:gold_ingot"].inventory_image,
	trigger = {
		type = "trade",
		target = 150,
	},
})
