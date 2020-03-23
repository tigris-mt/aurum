#!/bin/bash
set -e

# Modules developed alongside aurum. They are safe to update regularly with no chance of breakage.
SAFE="
	mods/core/b
	mods/core/gdamage
	mods/core/gemai
	mods/core/gnode_augment
	mods/env/fire
	mods/env/screalms
	mods/items/bucket
	mods/items/dye
	mods/items/gtextitems
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
