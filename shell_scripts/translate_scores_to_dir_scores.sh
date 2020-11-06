#!/bin/bash

# Converts a scores.txt file to a dirscores.txt file that shows
# the average scores on a per-directory basis

CUR=NONE; TOT=0; CNT=0
sort -k2 scores.txt | cut -d/ -f1-2 | while read LINE
	do SZ=$((${LINE// .*/} / 1024))
	D="${LINE/#* .\//}"
	if [ "$CUR" != "$D" ]
		then
		test "$CNT" != "0"  && test "$CUR" != "NONE" && echo "$((TOT / CNT)) $CUR"
		CUR="$D"
		TOT=0
		CNT=0

		else
		TOT=$((TOT + SZ))
		CNT=$((CNT + 1))
	fi
done | sort -gr > dirscores.txt
