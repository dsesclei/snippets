;Stolen from C02!

!to "header.o",plain
*=$0000
!08 $4e, $45, $53, $1a          ; "NES" plus character break
!08 $01                         ; 1 x 16K PRG-ROM page
!08 $01                         ; 1 x 8K CHR-ROM page
!08 $02                         ; H-mirror and battery backed SRAM ON.
!08 $00                         ; Required by iNES format
!08 $00,$00,$00,$00,$00,$00,$00,$00 ; Required by iNES format

