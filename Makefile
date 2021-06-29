# Config dependencies
config = mods/core/aurum/aurum_table.lua tools/config.sh
mods = mods/mapgen/aurum_villages

all: game.conf README.bbcode README.md menu screenshot.png $(mods)

# Game documentation & imaging.

menu: $(shell find screenshots) $(config)
	tools/make_images.sh

screenshot.png: $(shell find screenshots) $(config)
	tools/make_screenshot.sh

game.conf: docs/game.sh.conf $(config)
	tools/make_sh_doc.sh < $< > $@

README.md: docs/README.sh.md $(config)
	tools/make_sh_doc.sh < $< > $@

README.bbcode: README.md
	pandoc -f gfm -t tools/pandoc_bbcode_phpbb.lua -o $@ $<

# Mods

mods/mapgen/aurum_villages: mods/mapgen/aurum_villages/schematics/ruined_hall_jungle.mts

mods/mapgen/aurum_villages/schematics/ruined_hall_jungle.mts: mods/mapgen/aurum_villages/schematics/ruined_hall.mts
	tools/mts_replace.py < $< aurum_trees:drywood aurum_trees:pander > $@
