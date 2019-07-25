#!/usr/bin/env bash
set -e

version() {
	lua -e 'dofile("mods/core/aurum/aurum_table.lua"); print(aurum.VERSION)'
}

git tag -a "v$(version)" -m "v$(version)"
echo "New tag: v$(version)"
