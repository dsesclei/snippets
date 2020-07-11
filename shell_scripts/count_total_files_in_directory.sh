#!/bin/sh

# Count number of files and directories in this directory
for X in */
	do echo "$(find "$X" | wc -l) $X"
done | sort -g
