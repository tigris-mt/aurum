local S = minetest.get_translator()

awards.register_award("aurum_awards:eat", {
	title = S"Partaking of the Land",
	description = S"Eat any food.",
	trigger = {
		type = "eat",
		target = 1,
	},
})
