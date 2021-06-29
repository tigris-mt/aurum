export aurum=$(shell pwd)

all: game.conf README.bbcode README.md menu screenshot.png mods/mapgen/aurum_villages

.PHONY: .FORCE

mods/mapgen/aurum_villages: .FORCE
	$(MAKE) -C $@

config = mods/core/aurum/aurum_table.lua tools/config.sh

screenshot.png $(shell find menu): $(shell find screenshots) $(config)
	tools/images.sh

game.conf: docs/game.sh.conf $(config)
	tools/make_sh_doc.sh < $< > $@

README.md: docs/README.sh.md $(config)
	tools/make_sh_doc.sh < $< > $@

README.bbcode: README.md
	pandoc -f gfm -t tools/pandoc_bbcode_phpbb.lua -o $@ $<
