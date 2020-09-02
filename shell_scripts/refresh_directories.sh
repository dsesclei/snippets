#!/bin/sh

# Attempts to defragment a directory by moving its contents to a new temporary
# directory, deleting the old one, and renaming the new one to the original
# name, restoring the original modify time and permissions

TEMPNAME=__REFRESH_TEMP__

echo "Refreshing all directories in this directory"

rmdir -p $TEMPNAME 2>/dev/null
test -e $TEMPNAME && \
	echo "$TEMPNAME dir exists after rmdir attempt; aborting" && exit 1

for X in */
	do echo "$X"
	test -h "$X" && echo "Skipping symlink: $X" && continue
	rmdir -p $TEMPNAME 2>/dev/null
	DT="$(stat -c '%y' "$X" | cut -d. -f1)"
	PERM="$(stat -c '%a' "$X")"
	OWN="$(stat -c '%u:%g' "$X")"
	mkdir $TEMPNAME && \
		mv "$X"/* $TEMPNAME/ && \
		rmdir "$X" && \
		mv $TEMPNAME "$X"
	# Restore modify date/time, permissions, and UID/GID
	touch -d "$DT" "$X"
	chmod $PERM "$X"
	chown $OWN "$X"
done
