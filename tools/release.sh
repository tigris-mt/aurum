#!/bin/bash
set -e

. tools/config.sh

if ! [ "$(git rev-parse --abbrev-ref HEAD)" == "master" ]; then
	echo "Checkout not the master branch, cannot procede."
	exit 1
fi

if ! git diff-index --quiet HEAD --; then
	echo "Uncommitted changes, cannot procede."
	exit 1
fi

echo "Updating..."
tools/make_readme.sh
git add .
git commit -m "Release update: $(version)"

echo "Tagging..."
tools/tag.sh

echo "Pushing master..."
git push origin master:master

echo "Updating and pushing stable..."
git fetch . master:stable
git push origin stable:stable
