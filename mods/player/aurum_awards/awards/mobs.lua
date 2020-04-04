local S = minetest.get_translator()

awards.register_award("aurum_awards:first_blood", {
	title = S"First Blood",
	description = S"Slay any mob.",
	trigger = {
		type = "mob_kill",
		target = 1,
	},
})
