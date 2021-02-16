#!/bin/bash
set -e

cd "$(dirname "$0")"

if [ ! -d text ]; then mkdir text; fi

git log --pretty=reference > text/changelog.txt


