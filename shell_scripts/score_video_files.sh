#!/bin/bash

# Use ffprobe duration vs file size to "score" video file "weights"
#
# Primarily intended for downscaled archival transcoding
# A higher score indicates a greater size reduction
# This method is not at all perfect, but gives a general idea of what to
# transcode first to maximize free space as fast as possible
#
# This should be run in the root of a collection of folders with videos
# Accepts maximum scan depth as a paramter; default is 2 (one level down)

! ffprobe -version && echo "ffprobe does not work, aborting" && exit 1

SD="2000-01-01"
RD=$(date +%s -d "$SD 00:00:00")
BASERES=76800  # 320x240 - not 960x540 so we have a "fractional" component

test ! -z "$1" && MAXDEPTH="$1"
test -z "$MAXDEPTH" && MAXDEPTH=2

find -maxdepth $MAXDEPTH -type f -size +1000 | grep -e 'webm$' -e 'mkv$' -e 'mp4$' | while read FILE
	do
	# Calculate a multiplier based on the video resolution
	FULLRES=$(ffprobe "$FILE" 2>&1 | grep Stream.*Video: | tr ' ,' '\n' | grep '[0-9][0-9][0-9]*x[0-9][0-9][0-9]*')
	HRES=${FULLRES%%x*}
	VRES=${FULLRES##*x}
#	echo -e "FILE=$FILE\nHRES=$HRES\nVRES=$VRES\nBASERES=$BASERES\nFULLRES=$FULLRES"
	RES=$((HRES * VRES / BASERES))
	# Resolution multiplier must be at least 1
	test "$RES" -eq "0" && RES=1

	# Get file size in bytes using stat
	SZ=$(stat -c %s "$FILE")
	# Get duration of video in seconds
	DUR=$(ffprobe "$FILE" 2>&1 | grep -i 'duration\s*:\s' | tr -d \  | head -n 1 | cut -d: -f2-4 | cut -d. -f1)
	LD=$(date +%s -d "$SD $DUR")
	T=$(expr $(date +%s -d $DUR) - $(date +%s -d 00:00:00))
	test -z "$T" && T=999999999
	# size / length yields a "bitrate," then scale that up by resolution
	SCORE=$((SZ / T * RES))
#	echo "$SCORE  $RES  $T  $SZ  $FILE"
	echo "$SCORE $FILE"
done
