#!/bin/bash
set -e
. tools/config.sh

eval "echo \"$(cat docs/README.sh.md)\"" > README.md
pandoc -f gfm -t tools/pandoc_bbcode_phpbb.lua -o README.bbcode README.md
