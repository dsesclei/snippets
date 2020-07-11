!to "pagemove.o",plain
*=$4000

zp0=$f9
zp1=$fa
zp2=$fb
zp3=$fc
zp4=$fd
zp5=$fe

; ZP0 = start low byte
; ZP1 = start high byte
; ZP2 = new start low byte
; ZP3 = new start high byte
; ZP4 = number of bytes to move ($00 - $FF, where $00=1, $FF=256)

pagemove
	lda zp3			; Get dest. high byte
	cmp zp1			; Check against start high
	bmi pagemovedown	; If dest below start, move down
	beq +			; If equal, check low bytes to decide
	bne pagemoveup		; If greater, move up
+	lda zp2			; Get dest. low
	cmp zp0			; Check against start low
	bmi pagemovedown	; If less, move down
	bne pagemoveup		; If not equal (greater), move up
	rts			; Otherwise, start=dest so ignore call!

pagemovedown
	ldy #$00	; Init index
	ldx zp4		; Init counter
-	lda (zp0),y	; Load data byte
	sta (zp2),y	; Copy data byte
	cpx #$00	; Is counter at zero?
	beq +		; Yes = done
	iny		; Increment index
	dex		; Decrement counter
	clc
	bcc -		; Loop until done
+	rts

pagemoveup
	ldy zp4		; Init index/counter
-	lda (zp0),y	; Load data byte
	sta (zp2),y	; Save data byte
	cpy #$00	; Is counter at zero?
	beq +		; Yes = done
	dey		; Decrement index/counter
	clc
	bcc -		; Loop until done
+	rts
