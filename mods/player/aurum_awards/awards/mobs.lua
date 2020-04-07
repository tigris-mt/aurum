local S = minetest.get_translator()

awards.register_award("aurum_awards:first_blood", {
	title = S"First Blood",
	description = S"Slay any mob.",
	difficulty = 2,
	trigger = {
		type = "mob_kill",
		target = 1,
	},
})

awards.register_award("aurum_awards:mower", {
	title = S"Mower",
	requires = {"aurum_awards:first_blood"},
	description = S"Smite 100 mobs.",
	difficulty = 2,
	trigger = {
		type = "mob_kill",
		target = 100,
	},
})

awards.register_award("aurum_awards:reaper", {
	title = S"The Grim Reaper",
	requires = {"aurum_awards:mower"},
	description = S"Destroy 1000 mobs.",
	difficulty = 2,
	trigger = {
		type = "mob_kill",
		target = 1000,
	},
})

awards.register_award("aurum_awards:milker", {
	title = S"Titan, or Cyclops?",
	description = S"Milk 50 mobs.",
	difficulty = 3,
	trigger = {
		type = "mob_milk",
		target = 50,
	},
})
