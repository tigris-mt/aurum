local S = aurum.get_translator()

awards.register_award("aurum_awards:fertilizer", {
	title = S"You Cannot Eat Money",
	description = S"Place 15 fertilizer.",
	requires = {"aurum_awards:eat"},
	difficulty = 1,
	icon = minetest.inventorycube("aurum_farming_fertilizer.png", "aurum_farming_fertilizer.png", "aurum_farming_fertilizer.png"),
	trigger = {
		type = "place",
		node = "group:fertilizer",
		target = 15,
	},
})

