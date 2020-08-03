#!/bin/sh

# Deletes all empty directory trees under the specified or current dir

test -z "$DIR" && DIR="$1"
test -z "$DIR" && DIR=.

find "$DIR" -type d -exec rmdir -p --ignore-fail-on-non-empty -v '{}' +
