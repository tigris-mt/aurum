local S = minetest.get_translator()

awards.register_award("aurum_awards:dig_all", {
	title = S"Fledgling Sculptor",
	description = S"Dig 250 nodes.",
	difficulty = 1,
	trigger = {
		type = "dig",
		target = 250,
	},
})


