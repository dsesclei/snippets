#!/bin/bash

# MUST BE RUN UNDER MSYS2/MinGW, NOT ON LINUX/MAC SYSTEMS
#
# Generates batch files for mass downloading a YouTube archive
# Expects a channel map file in the following format:
# Name Of Video Channel=https://full_URL_to_channel_page.com/
# Lines in map file starting with '#' are ignored (commented out)
#
# This is intended to be used with a mapped network drive as root

test "$1" = "-h" && echo "vars: DRIVE, YTC, CHANMAP, BATFILE" && exit

test -z "$DRIVE" && DRIVE="Y:"
test -z "$YTC" && YTC="YouTube Channels"
test -z "$CHANMAP" && CHANMAP=yt_channel_mappings.txt
test -z "$BATFILE" && BATFILE=perform_yt_archive_update.bat

test ! -e "$CHANMAP" && echo "File $CHANMAP missing" && exit 1

echo "$DRIVE" > $BATFILE

while read LINE
	do [ -z "$LINE" ] && continue
	[ "${LINE:0:1}" = "#" ] && continue  # 0 processes
	NAME="${LINE/=http*/}" # 0 processes
	URL="${LINE/*=http/http}" # 0 processes
	URL="${URL/$'\r'/}"
#	test "$(echo "$LINE" | sed 's/\(^.\).*/\1/')" = "#" && continue # 2 processes
#	NAME="$(echo "$LINE" | sed 's/=http.*//')" # 2 processes
#	URL="$(echo "$LINE" | sed 's/.*=http/http/')" # 2 processes
	echo "NAME $NAME, URL $URL"
	echo "md \"\\$YTC\\$NAME\"" >> $BATFILE
	echo "cd \"\\$YTC\\$NAME\"" >> $BATFILE
	echo 'call \download_entire_youtube_channel "'$URL'"' >> $BATFILE
#	echo 'cd \' >> $BATFILE
done < "$CHANMAP"

echo 'cd \' >> $BATFILE

if [ "$(uname)" = "Linux" ]
	then sed 's/$/\r/' $BATFILE > foofooX; mv foofooX $BATFILE
fi
