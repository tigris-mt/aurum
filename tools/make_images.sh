#!/bin/bash
set -e
. tools/config.sh

rm -f menu/background*.png

let i=1
find screenshots -type f -not -name "$(screenshot)" -printf '%P\n' | while read n; do
	ln -sv ../screenshots/"$n" menu/background.$i.png
	let i=$i+1
done

ln -sv ../screenshots/"$(screenshot)" menu/background.png
