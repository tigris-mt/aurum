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

doc.add_category("rituals", {
	name = S"Rituals",
	build_formspec = doc.entry_builders.formspec,
})

doc.add_entry("basics", "rituals", {
	name = S"Rituals",
	data = {
		text = table.concat({
			S"Rituals are powerful invocations to perform certain magical actions.",
			S"All rituals are centered around an altar, but each ritual has its own rules.",
			S"Rituals and their setup are described in their own documentation category.",
		}, "\n"),
	},
})

aurum.dofile("rituals.lua")
aurum.dofile("spells.lua")

aurum.dofile("default_spells.lua")
aurum.dofile("default_rituals.lua")
