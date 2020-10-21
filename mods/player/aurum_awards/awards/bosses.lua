local S = aurum.get_translator()

awards.register_award("aurum_awards:boss_aurum", {
	title = S"Herald of Death",
	description = S"Slay an avatar of the Headstoner",
	icon = minetest.registered_items["aurum_fear:aurum"].inventory_image,
	requires = {"aurum_awards:equip"},
	difficulty = 1000,
	trigger = {
		type = "mob_kill",
		mob = "aurum_npcs:avatar_headstoner",
		target = 1,
	},
})

awards.register_award("aurum_awards:boss_primus", {
	title = S"Herald of Order",
	description = S"Slay an avatar of Mors Vivi",
	icon = minetest.registered_items["aurum_fear:primus"].inventory_image,
	requires = {"aurum_awards:equip", "aurum_awards:primus"},
	difficulty = 1000,
	trigger = {
		type = "mob_kill",
		mob = "aurum_npcs:avatar_mors_vivi",
		target = 1,
	},
})

awards.register_award("aurum_awards:boss_ultimus", {
	title = S"Herald of Chaos",
	description = S"Slay an avatar of Caligula",
	icon = minetest.registered_items["aurum_fear:ultimus"].inventory_image,
	requires = {"aurum_awards:equip", "aurum_awards:ultimus"},
	difficulty = 1000,
	trigger = {
		type = "mob_kill",
		mob = "aurum_npcs:avatar_caligula",
		target = 1,
	},
})

awards.register_award("aurum_awards:boss_loom", {
	title = S"Herald of Life",
	description = S"Slay an avatar of Mr. Decadence",
	icon = minetest.registered_items["aurum_fear:loom"].inventory_image,
	requires = {"aurum_awards:equip", "aurum_awards:loom"},
	difficulty = 1000,
	trigger = {
		type = "mob_kill",
		mob = "aurum_npcs:avatar_decadence",
		target = 1,
	},
})
