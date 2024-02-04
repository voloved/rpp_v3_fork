Route2Script:
	call Route2CheckHideCutTree
	jp EnableAutoTextBoxDrawing

Route2CheckHideCutTree:
	ld hl, wCurrentMapScriptFlags
	ld a, [hl]
	and %00110000
	res 4, [hl]
	res 5, [hl]
	ret z
	; d = Y loc
	; e = X loc
	ld d, 11
	ld e, 7
	farcall ClearCutTrees
	ld d, 30
	ld e, 6
	farcall ClearCutTrees
	ret

Route2TextPointers:
	dw PickUpItemText
	dw PickUpItemText
   	dw Route2Tree1
	dw Route2Tree2
	dw Route2Text3
	dw Route2Text4

Route2Text3:
	TX_FAR _Route2Text3
	db "@"

Route2Text4:
	TX_FAR _Route2Text4
	db "@"

Route2Tree1:
	TX_ASM
	ld a, 2 ; Tree number
	ld [wWhichTrade],a
	callba BerryTreeScript
	jp TextScriptEnd

Route2Tree2:
	TX_ASM
	ld a, 12 ; Tree number
	ld [wWhichTrade],a
	callba BerryTreeScript
	jp TextScriptEnd
