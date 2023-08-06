
MACRO StopAllMusic
	ld a, $ff
	call PlaySound
ENDM

Ch0    EQU 0
Ch1    EQU 1
Ch2    EQU 2
Ch3    EQU 3
Ch4    EQU 4
Ch5    EQU 5
Ch6    EQU 6
Ch7    EQU 7

MACRO audio
	db (_NARG - 2) << 6 | \2
	dw \1_\2
	IF _NARG > 2
		db \3
		dw \1_\3
	ENDC
	IF _NARG > 3
		db \4
		dw \1_\4
	ENDC
	IF _NARG > 4
		db \5
		dw \1_\5
	ENDC
ENDM

MACRO unknownsfx0x10
	db $dd ; soundinput
	db \1
ENDM

MACRO unknownsfx0x20
	; noise/sound
	db \1
	;db $20 | \1
	db \2
	db \3
	db \4
ENDM

MACRO unknownnoise0x20
	db \1 ; | $20
	db \2
	db \3
ENDM


;format: instrument length (in 16ths)
MACRO snare1
	db $B0 | (\1 - 1)
	db $01
ENDM

MACRO snare2
	db $B0 | (\1 - 1)
	db $02
ENDM

MACRO snare3
	db $B0 | (\1 - 1)
	db $03
ENDM

MACRO snare4
	db $B0 | (\1 - 1)
	db $04
ENDM

MACRO snare5
	db $B0 | (\1 - 1)
	db $05
ENDM

MACRO triangle1
	db $B0 | (\1 - 1)
	db $06
ENDM

MACRO triangle2
	db $B0 | (\1 - 1)
	db $07
ENDM

MACRO snare6
	db $B0 | (\1 - 1)
	db $08
ENDM

MACRO snare7
	db $B0 | (\1 - 1)
	db $09
ENDM

MACRO snare8
	db $B0 | (\1 - 1)
	db $0A
ENDM

MACRO snare9
	db $B0 | (\1 - 1)
	db $0B
ENDM

MACRO cymbal1
	db $B0 | (\1 - 1)
	db $0C
ENDM

MACRO cymbal2
	db $B0 | (\1 - 1)
	db $0D
ENDM

MACRO cymbal3
	db $B0 | (\1 - 1)
	db $0E
ENDM

MACRO mutedsnare1
	db $B0 | (\1 - 1)
	db $0F
ENDM

MACRO triangle3
	db $B0 | (\1 - 1)
	db $10
ENDM

MACRO mutedsnare2
	db $B0 | (\1 - 1)
	db $11
ENDM

MACRO mutedsnare3
	db $B0 | (\1 - 1)
	db $12
ENDM

MACRO mutedsnare4
	db $B0 | (\1 - 1)
	db $13
ENDM

MACRO duty
	;db $EC
	db $db
	db \1
ENDM

;format: rest length (in 16ths)
MACRO rest
	db $C0 | (\1 - 1)
ENDM

MACRO executemusic
	togglesfx
ENDM
