#!/bin/bash

# Copyright (C) 2021 by Jody Bruchon <jody@jodybruchon.com>
# Released under The MIT License

# Colorize output of 'diff' - like colordiff.org but not nearly as cool
# but doesn't require Perl so that's nice (but does require Bash)
# Probably works under ksh but definitely not POSIX sh

test -z "$DIFF" && DIFF=diff

CBLK=$'\033[30m' # Black
CRED=$'\033[31m' # Red
CGRN=$'\033[32m' # Green
CYEL=$'\033[33m' # Yellow
CBLU=$'\033[34m' # Blue
CPUR=$'\033[35m' # Purple (Magenta)
CCYA=$'\033[36m' # Cyan
CWHT=$'\033[37m' # White
COFF=$'\033[00m' # Disable all attributes

while IFS='' read -r LINE
	do
	BC="${LINE:0:1}"
#	echo "LINE='$LINE', BC='$BC'"
	case $BC in
		@|[0-9]) echo "$CCYA$LINE$COFF" ;;
		-|\<)    echo "$CRED$LINE$COFF" ;;
		+|\>)    echo "$CGRN$LINE$COFF" ;;
		*)       echo "$CWHT$LINE$COFF" ;;
	esac
done < <($DIFF $@)
