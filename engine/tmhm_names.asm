WriteTMPrefix::
	push hl
	push de
	push bc
	ld a, [wd11e]
	push af
	cp TM_01 ; is this a TM? [not HM]
	jp nc, .WriteTM
; if HM, then write "HM" and add 5 to the item ID, so we can reuse
	add 5
	ld [wd11e], a
	ld hl, HiddenPrefix ; points to "HM"
	ld bc, 2
	jp .continueWriting
.WriteTM
	ld hl, TechnicalPrefix ; points to "TM"
	ld bc, 2
.continueWriting
	ld de, wcd6d
	call CopyData
; now get the machine number and convert it to text
	ld a, [wd11e]
	sub TM_01 - 1
	ld b, "0"
.FirstDigit
	sub 10
	jr c, .SecondDigit
	inc b
	jr .FirstDigit
.SecondDigit
	add 10
	push af
	ld a, b
	ld [de], a
	inc de
	pop af
	ld b, "0"
	add b
	ld [de], a
	pop af
	push af
	inc de
; Type at the end
	ld b, a
	ld a, "-"
	ld [de], a
	ld a, b
	sub HM_01
	ld c, a
	ld b, 0
	ld hl, TMHMNameList
	ld a, 7
	call AddNTimes
	inc de
	ld bc, 7
	call CopyData
.endChar
	ld a, "@"
	ld [de], a
	pop af
	ld [wd11e], a
	pop bc
	pop de
	pop hl
	ret

TechnicalPrefix::
	db "TM"
HiddenPrefix::
	db "HM"

TMHMNameList:
INCLUDE "data/tmhm_names.asm"
