#!/bin/sh

if [ "$1" = "clean" ]
	then rm -f *.o out.nes
	exit
fi
		acme -v3 header.s
acme -v3 prg-rom.s
acme -v3 chr-rom.s
acme -v3 output.s
