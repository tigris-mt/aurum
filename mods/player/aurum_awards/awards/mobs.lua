local S = aurum.get_translator()

awards.register_award("aurum_awards:first_blood", {
	title = S"First Blood",
	description = S"Slay any mob.",
	icon = minetest.registered_items["aurum_tools:copper_machete"].inventory_image,
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
	icon = minetest.registered_items["aurum_tools:iron_machete"].inventory_image,
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
	icon = minetest.registered_items["aurum_tools:gold_machete"].inventory_image,
	difficulty = 2,
	trigger = {
		type = "mob_kill",
		target = 1000,
	},
})

awards.register_award("aurum_awards:milker", {
	title = S"Titan, or Cyclops?",
	description = S"Milk 50 mobs.",
	icon = minetest.registered_items["aurum_animals:bucket_milk"].inventory_image,
	difficulty = 3,
	trigger = {
		type = "mob_milk",
		target = 50,
	},
})
