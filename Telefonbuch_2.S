;***************************************************************
;* Telefonbuch 2.0                                             *
;* by Herwig Feichtinger                                       *
;* (c) 1981 in Anwendungsbeispiele                             *
;*     für den Mikroprozessor 6502                             *
;*                                                             *
;* Instructions:                                               *
;* =============                                               *
;*                                                             *
;* Prepare a first Data Entry                                  *
;* at $0201 by Hand!                                           *
;* 0201 0D                                                     *
;* 0202 3E                                                     *
;* 0203 00                                                     *
;*                                                             *
;* The Program saves the Data on tape,                         *
;* so this needs to be initialized once.                       *
;*                                                             *
;* Start the program at $0000                                  *
;* After the start you are in search mode.                     *
;* Enter a keyword and whole matching                          *
;* Lines of text will be presented.                            *
;*                                                             *
;* To change or add an entry press ESC                         *
;* change a line: Enter the identifying                        *
;* text to change, press Enter and                             *
;* insert a new Data Entry.                                    *
;*                                                             *
;* To add an entry Type >  and enter                           *
;* (after the ESC). Background: the last                       *
;* Byte of your Data File is a '>'.                            *
;* It will be deleted, an Entry added                          *
;* and a '>' will be added again to                            *
;* indicate the new end of the File.                           *
;*                                                             *
;* LOAD a File with ~P where P is a                            *
;* indicator for your File, as you can                         *
;* save more than one files on one tape.                       *
;*                                                             *
;* SAVE a File with ^P                                         *
;*                                                             *
;***************************************************************
    
RET      =       $0d
ESC      =       $1b
asterix  =       $2a
QUEST    =       $3f
HAT      =       $5e
TILDE    =       $7e

SAD      =       $1740
PADD     =       $1741
SBD      =       $1742
TimINIT  =       $1744
TIMER    =       $1747
hyBYT    =       $17f7
loBYT    =       $17f8
RDCHT    =       $1a24
RDBIT    =       $1a41
PRTPNT   =       $1e1e
CR       =       $1e2f
GETCH    =       $1e5a
INIT1    =       $1e8c
SPACE    =       $1e9e
OUTCH    =       $1ea0
INCPT    =       $1f63

         .org    $0000
init:    jsr     CR
         lda     #QUEST
         jsr     OUTCH
         jsr     SPACE
         lda     #$02
         sta     z:L00FB
         lda     #$00
         sta     z:L00FA
         ldx     #$18
@L0015:  sta     z:Buffer-1,x
         dex
         bne     @L0015
         jmp     LOADchk

L001D:   cmp     #ESC
         bne     @L0028
         lda     #$ff
         sta     z:Buffer
@L0025:  jsr     GETCH
@L0028:  cmp     #RET
         beq     @L0033
         sta     z:Buffer+1,x
         inx
         cpx     #$15
         bne     @L0025
@L0033:  jsr     INCPT
         ldy     #$00
         lda     (L00FA),y
         beq     init
         cmp     #RET
         bne     @L0033
@L0040:  ldx     #$00
@L0042:  iny
         lda     z:Buffer+1,x
         beq     @L0054
         lda     (L00FA),y
         cmp     #RET
         beq     @L0033
         cmp     z:Buffer+1,x
         bne     @L0040
         inx
         bne     @L0042
@L0054:  lda     z:Buffer
         bne     @L0071
         jsr     CR
         ldy     #$01
@L005D:  lda     (L00FA),y
         beq     @L006F
         cmp     #RET
         beq     @L0033
         sty     z:L00F9
         jsr     OUTCH
         ldy     z:L00F9
         iny
         bne     @L005D
@L006F:  beq     init

@L0071:  ldy     #$02
@L0073:  lda     (L00FA),y
         beq     @L0090
         cmp     #RET
         beq     @L007E
         iny
         bne     @L0073
@L007E:  sty     z:Buffer
@L0080:  ldy     z:Buffer
         lda     (L00FA),y
         beq     @L0090
         ldy     #$00
         sta     (L00FA),y
         jsr     INCPT
         clc
         bcc     @L0080

@L0090:  jsr     Prt_star
         inc     z:Buffer
         bne     @L00A0
         beq     @L00BE

@L0099:  jsr     GETCH
         cmp     #$08
         bne     @L00AE
@L00A0:  sec
         lda     z:L00FA
         sbc     #$01
         sta     z:L00FA
         bcs     @L00AB
         dec     z:L00FB
@L00AB:  clc
         bcc     @L0099

@L00AE:  cmp     #ESC
         beq     @L00C4
         cmp     #RET
         bne     @L00BB
         jsr     CR
         lda     #$0d
@L00BB:  iny
         sta     (L00FA),y
@L00BE:  jsr     INCPT
         clc
         bcc     @L0099

@L00C4:  iny
         lda     #$3e
         sta     (L00FA),y
         jsr     INCPT
         tya
         sta     (L00FA),y
         jsr     INCPT
         lda     z:L00FA
         sta     hyBYT
         lda     z:L00FB
         sta     loBYT
         jmp     init

Buffer:  .res    19,$00
L00F2:   .byte   $00
         .byte   $00
TAPE_ID: .byte   $00
         .byte   $00
         .byte   $00
         .byte   $00
         .byte   $00
L00F9:   .byte   $00
L00FA:   .byte   $00
L00FB:   .byte   $00


;part2
		 .org 	 $0100

load:    lda     #$00
         sta     L00FA
         lda     #$02
         sta     L00FB
         lda     #$7f
         sta     PADD
         lda     #$13
         sta     SBD
@L0112:  jsr     RDBIT
         lsr     TAPE_ID-1
         ora     TAPE_ID-1
         sta     TAPE_ID-1
         sta     SAD
@L011E:  cmp     #$16
         bne     @L0112
         jsr     RDCHT
         sta     SAD
         cmp     #$2a
         bne     @L011E
         jsr     RDCHT
         cmp     TAPE_ID
         beq     @L013F
         jsr     INIT1
         jsr     OUTCH
         jsr     SPACE
         jmp     load

@L013F:  sta     (L00FA),y
         jsr     INCPT
         jsr     RDCHT
         tax
         bne     @L013F
         sta     (L00FA),y
L014C:   jsr     INIT1
         jsr     PRTPNT
         jmp     init

         .byte   $00
         .byte   $00

save:    lda     #$00
         sta     L00FA
         lda     #$02
         sta     L00FB
         lda     #$27
         sta     TAPE_ID+1
         sta     TAPE_ID
         lda     #$bf
         sta     TimINIT-1
@L016A:  lda     #$16
         jsr     @L0188
         dec     TAPE_ID
         bne     @L016A
         lda     #$2a
         jsr     @L0188
@L0178:  ldy     #$00
         lda     (L00FA),y
         jsr     INCPT
         pha
         jsr     @L0188
         pla
         bne     @L0178
         beq     L014C

@L0188:  ldy     #$07
         sty     L00F2
@L018C:  ldy     #$02
         sty     TAPE_ID-1
@L0190:  ldx     @L01BE,y
         pha
@L0194:  bit     TIMER
         bpl     @L0194
         lda     @L01BF,y
         sta     TimINIT
         lda     TAPE_ID+1
         eor     #$80
         sta     SBD
         sta     TAPE_ID+1
         dex
         bne     @L0194
         pla
         dec     TAPE_ID-1
         beq     @L01B5
         bmi     @L01B9
         lsr     A
         bcc     @L0190
@L01B5:  ldy     #$00
         beq     @L0190

@L01B9:  dec     L00F2
         bpl     @L018C
         rts

@L01BE:  .byte   $02
@L01BF:  .byte   $c3
         .byte   $03
         .byte   $7e

Prt_star:
         lda     #asterix
         jsr     OUTCH
         jsr     CR
         rts

LOADchk: jsr     GETCH
         cmp     #TILDE
         bne     SAVEchk
         jsr     GETCH
         sta     TAPE_ID
         jsr     CR
         jmp     load

SAVEchk: cmp     #HAT
         bne     return
         jsr     GETCH
         sta     $0200
         jsr     SPACE
         jmp     save

return:  jmp     L001D

