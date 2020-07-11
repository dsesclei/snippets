#!/bin/bash

echo -n "Number of files: "
FILECOUNT=$(find -type f | wc -l)
echo "$FILECOUNT"
export FILECOUNT

echo -n "Number of directories: "
DIRCOUNT=$(find -type d | wc -l)
echo "$DIRCOUNT"
export DIRCOUNT

echo -n "Average file size: "
X=0
find -type f -exec stat -c '%s' '{}' \; | while read LINE
	do X=$((X + LINE)); echo $((X / FILECOUNT))
done | tail -n 1

echo -n "Smallest file size: "
X=99999999999
find -type f -exec stat -c '%s' '{}' \; | while read LINE
	do test $X -gt $LINE && X=$LINE && echo $LINE
done | tail -n 1


echo -n "Largest file size: "
X=0
find -type f -exec stat -c '%s' '{}' \; | while read LINE
	do test $X -lt $LINE && X=$LINE && echo $LINE
done | tail -n 1
