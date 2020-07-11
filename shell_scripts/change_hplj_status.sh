#!/bin/sh

# Change the READY status message on the screen of a compatible
# HP LaserJet network printer (such as the HPLJ 4000/4100)
# Suggestions: "FEED ME A CAT" or "OUT OF CRAYONS"
# Requires socat

PRINTER_IP=192.168.x.x

if ! socat -V 2>&1 >/dev/null; then echo "Install socat to use this" && exit 1
test "$1" = "" && echo "Enter a message too: $0 \"TONER AT GYM\"" && exit 1
echo '@PJL RDYMSG DISPLAY="'"$1"\" | socat -u - tcp-connect:$PRINTER_IP:9100

