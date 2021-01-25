#!/bin/sh

cd "$(dirname "$0")" || exit 1

cp /dev/null plist.txt
ls -1 *.ogg > plist.txt

exit 0
