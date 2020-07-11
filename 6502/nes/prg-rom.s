*=$c000
!to "prg-rom.o",plain

reset
        sei
	cld

; Disable all graphics
        lda #$00
        sta $2000
        sta $2001

; Spinlock on bit 7 of $2002 to wait for 2 VBlanks
init1
        lda $2002
        bpl init1
init2
        lda $2002
        bpl init2

; Init stack
        ldx #$ff
        txs

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
        jmp loop

nmi
; Start at $2000 and put 256 bytes of text in there.
; To make it simple, just use X to count 0-255. 
        lda #$20
        sta $2006
        lda #$20
        sta $2006
; Zero the scroll registers too!
        lda #$00
        sta $2005
        sta $2005
        ldx #$00
brafil
        stx $2007
        inx
        bne brafil

irq
        rti

palette
!08 $0e,$00,$0e,$19,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$01,$21
!08 $0e,$20,$22,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

*= $fffa
!16 nmi,reset,irq
