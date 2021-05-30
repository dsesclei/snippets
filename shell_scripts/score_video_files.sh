#!/bin/bash

# Use ffprobe duration vs file size to "score" video file "weights"
# Records the scores in a score file, skipping already-present entries
#
# Primarily intended for downscaled archival transcoding
# A higher score indicates a greater size reduction
# This method is not at all perfect, but gives a general idea of what to
# transcode first to maximize free space as fast as possible
#
# This should be run in the root of a collection of folders with videos
# Accepts maximum scan depth as a paramter; default is 2 (one level down)
# Change score file "database" path by setting SF prior to execution

! ffprobe -version && echo "ffprobe does not work, aborting" && exit 1

test ! -z "$1" && MAXDEPTH="$1"
test -z "$MAXDEPTH" && MAXDEPTH=2

test -z "$SF" && SF=scores.txt

SD="2000-01-01"
RD=$(date +%s -d "$SD 00:00:00")
BASERES=76800  # 320x240 - not 960x540 so we have a "fractional" component

# Stats
DROPPED=0
EXIST=0
ADDED=0
TOTAL=0

# Load scores file; skip any missing files
unset SFN
SCORES=0
test -e "$SF" && while read -r X
	do
	test -z "$X" && continue
	SFN[SCORES]="${X#* }"
	test ! -e "${SFN[$SCORES]}" && DROPPED=$((DROPPED + 1)) && continue
	SSZ[SCORES]="${X%% *}"
	SCORES=$((SCORES + 1))
	echo -en "Loading scores file: $SCORES\r"
done < "$SF"
echo

while read -r FILE
	do
	test -z "$FILE" && continue
	TOTAL=$((TOTAL + 1))
	[[ $((TOTAL % 10)) -eq 0 ]] && echo -en "\rDropped $DROPPED, checked $TOTAL, added $ADDED, already had $EXIST"
	# Check to see if the file is already present, and skip if so
	I=0
	while [[ $I -lt $SCORES ]]
		do
		if [[ "$FILE" == "${SFN[$I]}" ]]
			then
			EXIST=$((EXIST + 1))
			continue 2
		fi
		I=$((I + 1))
	done

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
	SCORE=$((SZ / T * RES))

	# Add score to score list
#	echo "$SCORE  $RES  $T  $SZ  $FILE"
	SCORES=$((SCORES + 1))
	SSZ[$SCORES]="$SCORE"
	SFN[$SCORES]="$FILE"
	ADDED=$((ADDED + 1))
done < <(find -maxdepth $MAXDEPTH -type f -size +1000 | grep -e 'webm$' -e 'mkv$' -e 'mp4$')
echo -e "\rScanned $TOTAL, added $ADDED, already had $EXIST, dropped $DROPPED"

# Build new score file
I=0
while [[ $I -lt $SCORES ]]
	do echo "${SSZ[$I]} ${SFN[$I]}"
	I=$(( I + 1 ))
done > "$SF"
