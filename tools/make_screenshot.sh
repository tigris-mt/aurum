#!/bin/bash
set -e
. tools/config.sh

ln -svf screenshots/"$(screenshot)" screenshot.png
touch screenshot.png
