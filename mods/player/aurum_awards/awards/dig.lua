local S = minetest.get_translator()

awards.register_award("aurum_awards:dig_all", {
	title = S"Cutting the Cake",
	description = S"Dig 250 nodes.",
	trigger = {
		type = "dig",
		target = 250,
	},
})


