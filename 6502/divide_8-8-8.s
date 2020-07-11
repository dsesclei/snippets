!to "divide888.o",plain
*=$4000

zp0=$f9
zp1=$fa

; Divides two 8-bit numbers with an 8-bit result
; zp0=numerator, zp1=denominator
; Out: zp0=quotient, zp1=remainder

divide888
	lda #$00
	ldx #$08
	asl zp0
-	rol
	cmp zp1
	bcc +
	sbc zp1
+	rol zp0
	dex
	bne -
	sta zp1
	rts
