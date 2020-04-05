local S = minetest.get_translator()

awards.register_award("aurum_awards:eat", {
	title = S"Partaking of the Land",
	description = S"Eat any food.",
	trigger = {
		type = "eat",
		target = 1,
	},
})

awards.register_award("aurum_awards:eat_good", {
	title = S"Bring Only the Best",
	description = S"Eat 10 morale-boosting foods.",
	requires = {"aurum_awards:eat"},
	trigger = {
		type = "eat",
		item = "group:edible_morale",
		target = 10,
	},
})
