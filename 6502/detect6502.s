!to "detect6502.o",plain
!cpu 65816
*=$4000

; WARNING: the value in zp0 may be executed as an opcode on CMOS 6502
; chips during the bit-op test. Storing the result in an address that
; consitutes the wrong opcode could result in a crash (for example, if
; $40 is used, a 65C02 without bit-op extensions will execute RTI!)
; Two- or three-byte opcodes in zp0 will cause trouble as well!
; Anything ending in $x3 or $xB will be interpreted as NOP and should
; be safe.
zp0=$fb
zp1=$fc
zp2=$fd

; Detects the CPU in use
; 76543210
; |||||||'-- 0=NMOS 6502 (or 65816 if bit 1 ON), 1=65C02 or variant
; ||||||'--- 0=6502 series, 1=65816 series
; |||||'---- 0=Early 6502 w/bad ROR instruction, 1=ROR is normal
; ||||'----- 0=No decimal mode (Ricoh 2A03), 1=decimal mode OK
; |||'------ 1=Hudson Soft HuC6280 CPU
; ||'------- 1=Bit-op capable 65C02 (RMB/SMB/BBR/BBS opcodes available)
; |'-------- 1=Mitsubishi/Renesas 740 CPU
; '--------- 1=Renesas 740 with MUL/DIV instructions

detect6502
	lda #$02	; Initialize for 740 MUL/DIV test
	sta zp2
; Test for NMOS/CMOS and 6502/65816
	lda #$00
	sta zp1		; Initialize for 740 series test
	inc
	cmp #$01
	bmi +
	xba
	dec
	xba
	inc
+	sta zp0		; 0=6502, 1=65C02, 2=65C816
; Test for very early 6502s with bad ROR instruction
	lda #$08
	clc
	ror
	cmp #$04
	bne +		; 6502 with bad ROR instruction
	ora zp0
	sta zp0		; 4 = good ROR
; Test for Ricoh 2A03 (NES) which has no decimal mode
+	cli		; C64 KERNAL can't handle D set on IRQ
	sed
	lda #$09
	clc
	adc #$01
	cmp #$10
	bne +		; Decimal mode failed
	lsr		; $10 -> $08
	ora zp0
	sta zp0
; Test for Hudson Soft HuC6280 CPU
+	cld
	sei
	and #$01	; Skip remaining tests if not CMOS
	beq ++
	php
	ldy #$01
	rep #$08	; HuC6280 sees "CLY,PHP" instead
	cpy #$00
	bne +		; Not a HuC6280 CPU
	plp		; Undo the PHP instruction
	lda #$20
	ora zp0
	sta zp0		; Set HuC6280 flag
; Test for 65C02 with bit-op instructions
; This is pitifully simple: it sets the flag bit for us!
+	!byte $d7,zp0	; WARNING: zp0 becomes opcode if SMB5 not usable!
; Test for Mitsubishi/Renesas 740 series CPU
	!byte $3c	; LDM on 740, BIT on 65C02 
	!byte $40,zp1	; 740 sets zp1 to $40
	lda zp1
	beq ++		; If not a 740, end testing
	ora zp0		; Should already contain $40
	sta zp0
	lda #$02
	!byte $62,zp2	; MUL zp2
	cmp #$04	; If MUL is supported, 2*2=4
	bne ++
	lda #$80	; Set 740 MUL/DIV flag
	ora zp0
	sta zp0
++	rts

