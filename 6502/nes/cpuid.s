*=$c000
!to "prg-rom.o",plain
!cpu 65816

reset
	sei
	cld

; Disable all graphics
	lda #$00
	sta $2000
	sta $2001

; Init stack
	ldx #$ff
	txs

; Spinlock on bit 7 of $2002 to wait for 2 VBlanks
-	lda $2002
	bpl -
-	lda $2002
	bpl -

; Load palette from table below
	lda #$3f
	ldx #$00
	sta $2006
	stx $2006
palload
	lda palette,x
	sta $2007
	inx
	cpx #$20
	bne palload

; Preload attribute table
attrib
	lda #$23
	sta $2006
	lda #$c0
	sta $2006
	lda #$ff
	ldx #$40
fillattrib
	sta $2007
	dex
	bne fillattrib


; Set basic PPU registers.  Load background from $0000,
; sprites from $1000, and the name table from $2000.
; Sets sprites to be off, BG on, VBlank NMI on.

	lda #%10001000
	sta $2000
	lda #%00001110
	sta $2001

loop
; Infinite loop.  w00t.
cpuid

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
; ||||||''-- 0=NMOS 6502 (or 65816 if bit 1 ON), 1=65C02 or variant
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

; End CPU ID code

++	lda zp0
byte2hex
byte2hexhigh
  lsr	 ; Translate high down to low
  lsr
  lsr
  lsr
  clc
  adc #$30    ; ASCII 0 = $30
  cmp #$3a    ; Is it going to be a-f?
  bmi byte2hexhigh1     ; No = go ahead and send
  sec
  sbc #$39    ; Translate down to CHR-ROM letters
byte2hexhigh1
  sta zp1
  lda zp0
  and #$0f    ; Cut high nybble out
  clc
  adc #$30
  cmp #$3a
  bmi byte2hexlow1
  sec
  sbc #$39
byte2hexlow1
  sta zp2

sp0=$0100

	lda zp0
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
	jmp loop

nmi
text
	lda $2002	; Read PPUSTATUS to reset addr latch
	lda #$20
	sta $2006	
	sta $2006
	ldx #$00
	stx $2005
	stx $2005
	lda zp1
	sta $2007
	lda zp2
	sta $2007
	ldx #$00
-	lda sp0,x
	sta $2007
	inx
	cpx #$08
	bne -

irq
	rti

palette
!08 $0e,$00,$0e,$19,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$01,$21
!08 $0e,$20,$22,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

*= $fffa
!16 nmi,reset,irq

