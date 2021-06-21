#!/bin/bash
set -e

# Modules developed alongside aurum. They are safe to update regularly with no chance of breakage.
SAFE="
	mods/core/b
	mods/core/gdamage
	mods/core/gemai
	mods/core/gglobaltick
	mods/core/gnode_augment
	mods/env/bright_night
	mods/env/fire
	mods/entities/gprojectiles
	mods/items/boats
	mods/items/bucket
	mods/items/doors
	mods/items/dye
	mods/items/elevator
	mods/items/gtextitems
	mods/items/signs_lib
	mods/mapgen/screalms
	mods/player/creative
	mods/player/gequip
	mods/player/xmana
	mods/treasurer/tsm_agnostic_dungeon
"

echo "Updating safe submodules..."

for m in $SAFE; do
	echo "$m"
	git submodule update --remote --init --recursive "$m" &
done

wait
