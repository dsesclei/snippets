!to "multiply8816.o",plain
*=$4000

zp0=$f9
zp1=$fa

; Multiplies two 8-bit numbers with a 16-bit result.
; zp1=multiplicand, zp0=multiplier
; Out: zp0/zp1=result

; ZP1 must be set to the multiplicand, and X to the multiplier.

multiply8
	ldx zp0
	lda #$00
	sta zp0		; Init result
	ldy #$08	; Init multiplier loop
-	asl zp0		; Shift low byte left
	rol zp1		; Shift high byte left
	bcc +		; No carry = loop around
	clc
	txa		; Move multiplier into A
	adc zp0		; Add multiplier to result
	sta zp0		; Store new low byte
	lda zp1		; Load high byte
	adc #$00	; Add carry (if any) to high byte
	sta zp1		; Store new high byte
+	dey		; Decrement counter
	bne -		; If not zero, do again
	rts 
