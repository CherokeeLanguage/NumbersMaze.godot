#!/bin/bash
set -e

cd "$(dirname "$0")"

if [ ! -d text ]; then mkdir text; fi

(
echo "--- CHANGELOG ---" 
echo
git log --pretty=reference
echo
echo "--- Previous Repo: NumbersMaze ---"
echo
cat text/changelog.prev2.txt
echo
echo "--- Previous Repo: CherokeeNumbersMaze ---"
echo
cat text/changelog.prev1.txt
) > text/changelog.txt