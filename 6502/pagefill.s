!to "pagefill.o",plain
*=$4000

zp0=$fb
zp1=$fc
zp2=$fd

; Fill a range of 256 bytes or less with a value

; ZP0 = start low byte
; ZP1 = start high byte
; ZP2 = number of bytes to fill ($00 - $FF, where $00=1, $FF=256)
; Y gets clobbered
; A = fill byte

pagefill
	ldy #$00
-	sta (zp0),y	; Store fill byte
	cpy zp2		; Last byte reached?
	beq +		; If so, end fill
	iny		; If not, move to next byte
	bne -		; and loop until done
+	rts
