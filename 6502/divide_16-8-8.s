!to "divide1688.o",plain
*=$4000

zp0=$fb
zp1=$fc
zp2=$fd

; Divides a 16-bit number by an 8-bit number
; and produces an 8-bit result
; zp0/zp1=numerator, zp2=denominator
; Out: zp0=quotient, zp1=remainder

divide1688
	lda zp1
	ldx #$08
	asl zp0
--	rol
	bcs +
	cmp zp2
	bcc ++
+	sbc zp2
	sec
++	rol zp0
	dex
	bne --
	sta zp1
	rts
