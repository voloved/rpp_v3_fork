Route1Script:
	jp EnableAutoTextBoxDrawing
	ld hl, Route1ScriptPointers
	jp CallFunctionInTable

Route1ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route1TextPointers:
	dw Route1Text1
	dw Route1Text2
	dw Route1Tree1
	dw Route1OakText
	dw Route1Text3

Route1Text1:
	TX_ASM
	CheckAndSetEvent EVENT_GOT_POTION_SAMPLE
	jr nz, .asm_1cada
	ld hl, Route1ViridianMartSampleText
	call PrintText
	lb bc, POTION, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, Route1Text_1cae8
	jr .asm_1cadd
.BagFull
	ld hl, Route1Text_1caf3
	jr .asm_1cadd
.asm_1cada
	ld hl, Route1Text_1caee
.asm_1cadd
	call PrintText
	jp TextScriptEnd

Route1ViridianMartSampleText:
	TX_FAR _Route1ViridianMartSampleText
	db "@"

Route1Text_1cae8:
	TX_FAR _Route1Text_1cae8
	TX_SFX_ITEM_1
	db "@"

Route1Text_1caee:
	TX_FAR _Route1Text_1caee
	db "@"

Route1Text_1caf3:
	TX_FAR _Route1Text_1caf3
	db "@"

Route1Text2:
	TX_FAR _Route1Text2
	db "@"

Route1Text3:
	TX_FAR _Route1Text3
	db "@"
	
Route1Tree1:
	TX_ASM
	ld a, 1 ; Which berry tree
	ld [wWhichTrade], a
	callba BerryTreeScript
	jp TextScriptEnd

Route1OakText:
	TX_ASM
	CheckAndSetEvent EVENT_BEAT_PROF_OAK
	jr nz, .alreadyBattled
	ld hl, OakBeforeBattleText
	jr .printQuestion
.alreadyBattled
	ld hl, OakAlreadyBattled
.printQuestion
	call PrintText
	call YesNoChoice ; this whole bit doesn't work for some reason
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	
	ld hl, OakYes
	call PrintText
	ld c, 0 ; BANK(Music_MeetMaleTrainer)
	ld a, MUSIC_MEET_MALE_TRAINER
	call PlayMusic

	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	
	call Delay3
	ld a, OPP_PROF_OAK
	ld [wCurOpponent], a

	; select which team to use during the encounter
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, .NotSquirtle
	ld a, $2 ; Rival had squirtle, so i had charmander
	jr .done
.NotSquirtle
	cp STARTER3
	jr nz, .Charmander
	ld a, $3 ; bulb, so i had squirtle
	jr .done
.Charmander
	ld a, $1 ; char, so i had bulbasaur
.done
	ld [wTrainerNo], a
	ld a, 1
	ld [wIsTrainerBattle], a
	
	ld hl, OakDefeatedText
	ld de, OakWonText
	call SaveEndBattleTextPointers
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	xor a
	jp TextScriptEnd
.refused
	ld hl, OakNo
.textCont
	call PrintText
	jp TextScriptEnd

OakBeforeBattleText:
	TX_FAR _OakBeforeBattleText
	db "@"

OakYes:
	TX_FAR _OakYes
	db "@"

OakNo:
	TX_FAR _OakNo
	db "@"

OakAlreadyBattled:
	TX_FAR _OakAlreadyBattled
	db "@"

OakDefeatedText:
	TX_FAR _OakDefeatedText
	db "@"

OakWonText:
	TX_FAR _OakWonText
	db "@"

