#!/bin/sh

# Clean up MPC-HC thumbnail image names a bit

find -name '*_thumbs*.jpg' | while read LINE
	do mv "$LINE" "$(echo "$LINE" | sed 's/_thumbs.*\.jpg/.jpg/')"
done
