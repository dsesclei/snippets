!to "binary.o",plain
*=4000

; Convert byte in A to an 8-number binary string
; stored at sp0

sp0=$0100

byte2bin
	clc
	rol
	ldx #$07
-	ror
	tay
	and #$01
	beq +
	lda #$31	; $31 = 1
	sta sp0,x
	clc
	bcc ++
+	lda #$30	; $30 = 0
	sta sp0,x
++	tya
	dex
	bne -
	rts
