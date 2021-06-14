local S = aurum.get_translator()
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

gequip.register_type("hands", {
	description = S"Hands",
	list_name = "hand",
})

b.dofile("actions.lua")
b.dofile("armor.lua")
b.dofile("doc.lua")
b.dofile("shaper_gloves.lua")
b.dofile("wear.lua")
