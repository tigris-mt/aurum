#!/bin/bash
set -e
. tools/config.sh

let i=1
while read n; do
	ln -svfn "../screenshots/$n" menu/background.$i.png
	let i=$i+1
done < <(find screenshots -type f -not -name "$(screenshot)" -printf '%P\n')

while read n; do
	if [[ "$(echo "$n" | cut -d. -f2)" -ge $i ]]; then
		rm "$n"
	fi
done < <(find menu -name 'background.*.png')

ln -svfn "../screenshots/$(screenshot)" menu/background.png
