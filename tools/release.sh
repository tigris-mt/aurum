#!/bin/bash
set -e

version() {
	lua -e 'dofile("mods/core/aurum/aurum_table.lua"); print(aurum.VERSION)'
}

mtversion() {
	lua -e 'dofile("mods/core/aurum/aurum_table.lua"); print(aurum.MT_VERSION)'
}

if ! [ "$(git rev-parse --abbrev-ref HEAD)" == "master" ]; then
	echo "Checkout not the master branch, cannot procede."
	exit 1
fi

if ! git diff-index --quiet HEAD --; then
	echo "Uncommitted changes, cannot procede."
	exit 1
fi

echo "Updating..."
eval "echo \"$(cat docs/README.sh.md)\"" > README.md
pandoc -f markdown_github -t tools/pandoc_bbcode_phbb.lua -o README.bbcode README.md
git add .
git commit -m "Release update: $(version)"

echo "Tagging..."
tools/tag.sh

echo "Pushing master..."
git push origin master:master

echo "Updating and pushing stable..."
git fetch . master:stable
git push origin stable:stable
