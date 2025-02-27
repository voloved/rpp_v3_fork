; rgbds macros

MACRO note
	db \1 << 4 + (\2 - 1)
	ENDM

; pitch
__ EQU 0
C_ EQU 1
C# EQU 2
D_ EQU 3
D# EQU 4
E_ EQU 5
F_ EQU 6
F# EQU 7
G_ EQU 8
G# EQU 9
A_ EQU 10
A# EQU 11
B_ EQU 12

MACRO inc_octave
	db $f4
	ENDM

MACRO dec_octave
	db $f5
	ENDM

MACRO notetype0
	db $f6, \1
	ENDM

MACRO notetype1
	db $f7, \1
	ENDM

MACRO notetype2
	db $f8, \1
	ENDM

MACRO musicheader
	; number of tracks, track idx, address
	dbw ((\1 - 1) << 6) + (\2 - 1), \3
	endm
