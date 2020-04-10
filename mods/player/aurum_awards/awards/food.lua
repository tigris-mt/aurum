local S = minetest.get_translator()

awards.register_award("aurum_awards:eat", {
	title = S"Partaking of the Land",
	description = S"Eat any food.",
	icon = "aurum_animals_cooked_meat.png",
	difficulty = 1,
	trigger = {
		type = "eat",
		target = 1,
	},
})

awards.register_award("aurum_awards:eat_good", {
	title = S"Bring Only the Best",
	description = S"Eat 10 morale-boosting foods.",
	icon = "aurum_chef_makeshift_pumpkin_pie.png",
	difficulty = 5,
	requires = {"aurum_awards:eat"},
	trigger = {
		type = "eat",
		item = "group:edible_morale",
		target = 10,
	},
})
