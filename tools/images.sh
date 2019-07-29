#!/bin/bash
set -e

COVER="$(basename "$(readlink screenshot.png)")"

rm -f menu/background*.png

let i=1
find screenshots -type f -not -name "$COVER" -printf '%P\n' | while read n; do
	ln -sv ../screenshots/"$n" menu/background.$i.png
	let i=$i+1
done

ln -sv ../screenshots/"$COVER" menu/background.png
