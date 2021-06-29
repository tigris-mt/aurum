export aurum=$(shell pwd)

all: mods/mapgen/aurum_villages

.PHONY: .FORCE

mods/mapgen/aurum_villages: .FORCE
	$(MAKE) -C $@
