local S = aurum.get_translator()

awards.register_award("aurum_awards:loom", {
	title = S"Flame Seeker",
	description = S"Enter the Loom.",
	difficulty = 50,
	icon = "fire_basic_flame.png",
	trigger = {
		type = "realm_change",
		realm = "aurum:loom",
		target = 1,
	},
})

awards.register_award("aurum_awards:realm_warper", {
	title = S"Realm Warper",
	description = S"Shift realms 100 times.",
	requires = {"aurum_awards:loom"},
	difficulty = 10,
	icon = "aurum_portals_base.png",
	trigger = {
		type = "realm_change",
		target = 100,
	},
})

awards.register_award("aurum_awards:primus", {
	title = S"Rural Exploration",
	description = S"Enter Primus Hortum.",
	difficulty = 70,
	requires = {"aurum_awards:loom"},
	icon = "aurum_farming_fertilizer.png",
	trigger = {
		type = "realm_change",
		realm = "aurum:primus",
		target = 1,
	},
})

awards.register_award("aurum_awards:ultimus", {
	title = S"Urban Exploration",
	description = S"Enter Ultimus Hortum.",
	requires = {"aurum_awards:loom"},
	difficulty = 70,
	icon = "aurum_clay_brick.png",
	trigger = {
		type = "realm_change",
		realm = "aurum:primus",
		target = 1,
	},
})

awards.register_award("aurum_awards:aether", {
	title = S"The Realm of Hyperion",
	description = S"Enter the Aether.",
	requires = {"aurum_awards:loom"},
	difficulty = 75,
	icon = "aurum_base_aether_shell.png",
	trigger = {
		type = "realm_change",
		realm = "aurum:aether",
		target = 1,
	},
})
