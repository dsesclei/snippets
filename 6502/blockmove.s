!to "blockmove.o",plain
*=$4000

zp0=$f9
zp1=$fa
zp2=$fb
zp3=$fc
zp4=$fd
zp5=$fe


blockmovedown
	ldy #$00
--	lda (zp2),y	; Load data byte
	sta (zp0),y	; Store data in destination
	lda zp2		; Load data start low
	cmp zp4		; Compare to data start low
	beq ++		; If equal, check high too
-	inc zp0		; Increment dest start low byte
	bne +		; If dest start = 0 don't inc high
	inc zp1		; Otherwise increment high
+	inc zp2		; Increment data start low byte
	bne +		; If low byte non-zero, don't inc high
	inc zp3		; Otherwise inc high
+	clc
	bcc --		; Loop until done
++	lda zp3		; Load data start high
	cmp zp5		; Compare against data end high
	bne -		; If not equal, return to loop
	rts

blockmoveup
	ldy #$00	; Initialize index (only want indirection)
--	lda (zp2),y	; Load data byte
	sta (zp0),y	; Store data in destination
	lda zp2		; Get data end low byte
	cmp zp4		; Compare against data start low
	beq ++		; If equal, possibly done, so check
-	lda zp0		; Get data dest. end low
	bne +		; if zp0 not 0, don't dec high byte
	dec zp1		; Otherwise decrement high byte
+	dec zp0		; Decrement data dest. end low byte
	lda zp2		; Load data end low byte
	bne +		; If not 0, don't dec data end high
	dec zp3		; Decrement data end high byte
+	dec zp2		; Decrement data end low byte
	clc
	bcc --		; Loop until zp2/3 = zp4/5
++	lda zp3		; Load data end high byte
	cmp zp5		; Check against data start high
	bne -		; If not equal, return to loop
	rts
