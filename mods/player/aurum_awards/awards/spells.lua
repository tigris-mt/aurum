local S = aurum.get_translator()

awards.register_award("aurum_awards:magician", {
	title = S"Magician",
	description = S"Cast a spell.",
	icon = "aurum_rods_rod.png",
	difficulty = 10,
	trigger = {
		type = "spell_rod_use",
		target = 1,
	},
})

awards.register_award("aurum_awards:wizard", {
	title = S"Wizard",
	description = S"Cast 100 spells.",
	icon = "aurum_scrolls_scroll_full.png^aurum_rods_rod.png",
	requires = {"aurum_awards:magician"},
	difficulty = 10,
	trigger = {
		type = "spell_rod_use",
		target = 100,
	},
})
