local S = minetest.get_translator()
aurum.magic = {}

doc.add_category("spells", {
	name = S"Spells",
	build_formspec = doc.entry_builders.text,
})

doc.add_entry("basics", "spells", {
	name = S"Spells",
	data = {
		text = table.concat({
			S"Spells are found within Spell Scrolls. There are various levels of each spell's power.",
			S"They can be produced through ritual or found in the world.",
			S"They can be applied to certain objects like rods for use.",
		}, "\n"),
	},
})

aurum.dofile("rituals.lua")
aurum.dofile("spells.lua")

aurum.dofile("default_spells.lua")
