INCLUDE "macros/asm_macros.asm"
INCLUDE "macros/data_macros.asm"
INCLUDE "macros/text_macros.asm"
INCLUDE "macros/audio_macros.asm"
INCLUDE "macros/event_macros.asm"


; Macros for color hack

;MACRO ORG
;	SECTION "ORG\@",ROMX[\2],BANK[\1]
;	ENDM

; rst $18 = bankswitch
MACRO CALL_INDIRECT
	ld b, BANK(\1)
	ld hl, \1
	rst $18
ENDM
