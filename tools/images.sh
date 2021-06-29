#!/bin/bash
set -e
. tools/config.sh

touch_ln() {
	ln -sv "$1" "$2"
	touch "$2"
}

rm -f screenshot.png
touch_ln screenshots/"$(screenshot)" screenshot.png

rm -f menu/background*.png

let i=1
find screenshots -type f -not -name "$(screenshot)" -printf '%P\n' | while read n; do
	touch_ln ../screenshots/"$n" menu/background.$i.png
	let i=$i+1
done

touch_ln ../screenshots/"$(screenshot)" menu/background.png
