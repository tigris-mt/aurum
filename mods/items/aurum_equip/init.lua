local S = minetest.get_translator()
aurum.equip = {}

gequip.register_type("head", {
	description = S"Head",
})

gequip.register_type("chest", {
	description = S"Chest",
})

gequip.register_type("legs", {
	description = S"Legs",
})

gequip.register_type("feet", {
	description = S"Feet",
})

aurum.dofile("actions.lua")
aurum.dofile("armor.lua")
