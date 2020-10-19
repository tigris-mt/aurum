local S = aurum.get_translator()

minetest.register_craftitem("aurum_fear:aurum", {
	description = S"The Fear of Death",
	groups = {fear = 1},
	inventory_image = "aurum_fear_fear.png^[colorize:#00FF00",
})

minetest.register_craftitem("aurum_fear:primus", {
	description = S"The Fear of Order",
	groups = {fear = 1},
	inventory_image = "aurum_fear_fear.png^[colorize:#009900",
})

minetest.register_craftitem("aurum_fear:ultimus", {
	description = S"The Fear of Chaos",
	groups = {fear = 1},
	inventory_image = "aurum_fear_fear.png^[colorize:#222299",
})

minetest.register_craftitem("aurum_fear:loom", {
	description = S"The Fear of Life",
	groups = {fear = 1},
	inventory_image = "aurum_fear_fear.png^[colorize:#FF0000",
})
