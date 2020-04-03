#!/usr/bin/env bash
set -e

. tools/config.sh

git tag -a "v$(version)" -m "v$(version)"
echo "New tag: v$(version)"
