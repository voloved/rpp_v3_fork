GainExperience:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z ; return if link battle
;	call DivideExpDataByNumMonsGainingExp
	ld hl, wPartyMon1
	xor a
	ld [wWhichPokemon], a
	ld [wExpShareTextShown], a ; Flag to see if EXP Share text was shown
.partyMonLoop ; loop over each mon and add gained exp
	inc hl
	ld a, [hli]
	or [hl] ; is mon's HP 0?
	jp z, .nextMon ; if so, go to next mon
	push hl
	ld hl, wPartyGainExpFlags
	ld a, [wWhichPokemon]
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a ; is mon's gain exp flag set?
	pop hl
	jp z, .nextMon ; if mon's gain exp flag not set, go to next mon
	ld de, (wPartyMon1HPExp + 1) - (wPartyMon1HP + 1)
	add hl, de
	ld d, h
	ld e, l
	ld hl, wEnemyMonBaseStats
	ld c, NUM_STATS
.gainStatExpLoop
	ld a, [hli]
	ld b, a ; enemy mon base stat
	ld a, [de] ; stat exp
	add b ; add enemy mon base state to stat exp
	ld [de], a
	jr nc, .nextBaseStat
; if there was a carry, increment the upper byte
	dec de
	ld a, [de]
	inc a
	jr z, .maxStatExp ; jump if the value overflowed
	ld [de], a
	inc de
	jr .nextBaseStat
.maxStatExp ; if the upper byte also overflowed, then we have hit the max stat exp
	ld a, $ff
	ld [de], a
	inc de
	ld [de], a
.nextBaseStat
	dec c
	jr z, .statExpDone
	inc de
	inc de
	jr .gainStatExpLoop
.statExpDone
	xor a
	ld [H_MULTIPLICAND], a
	ld [H_MULTIPLICAND + 1], a
	ld a, [wEnemyMonBaseExp]
	ld [H_MULTIPLICAND + 2], a
	ld a, [wEnemyMonLevel]
	ld [H_MULTIPLIER], a
	call Multiply
	ld a, 7
	ld [H_DIVISOR], a
	ld b, 4
	call Divide
	ld hl, wPartyMon1OTID - (wPartyMon1DVs - 1)
	add hl, de
	ld b, [hl] ; party mon OTID
	inc hl
	ld a, [wPlayerID]
	cp b
	jr nz, .tradedMon
	ld b, [hl]
	ld a, [wPlayerID + 1]
	cp b
	ld a, 0
	jr z, .next
.tradedMon
	push hl
	ld hl, wExtraFlags
	bit 2,[hl]
	pop hl
	jr nz, .noBoost
	call BoostExp ; traded mon exp boost
	ld a, 1
	jr .next
.noBoost
	ld a, 0 ; Makes traded Pokemon act the same as normal ones
.next
	ld [wGainBoostedExp], a
	ld a, [wIsInBattle]
	dec a ; is it a trainer battle?
	call nz, BoostExp ; if so, boost exp
	inc hl
	inc hl
	inc hl
; add the gained exp to the party mon's exp
	ld b, [hl]
	ld a, [H_QUOTIENT + 3]
	ld [wExpAmountGained + 1], a
	add b
	ld [hld], a
	ld b, [hl]
	ld a, [H_QUOTIENT + 2]
	ld [wExpAmountGained], a
	adc b
	ld [hl], a
	jr nc, .noCarry
	dec hl
	inc [hl]
	inc hl
.noCarry
; calculate exp for the mon at max level, and cap the exp at that value
	inc hl
	push hl
	ld a, [wWhichPokemon]
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl] ; species
	ld [wd0b5], a
	call GetMonHeader
	ld d, MAX_LEVEL
	callab CalcExperience ; get max exp
; compare max exp with current exp
	ld a, [hExperience]
	ld b, a
	ld a, [hExperience + 1]
	ld c, a
	ld a, [hExperience + 2]
	ld d, a
	pop hl
	ld a, [hld]
	sub d
	ld a, [hld]
	sbc c
	ld a, [hl]
	sbc b
	jr c, .next2
; the mon's exp is greater than the max exp, so overwrite it with the max exp
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hld], a
	dec hl
.next2
	push hl
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, GainedText
	ld a, [wBoostExpByExpAll] ;get using ExpAll flag
	and a
	jr z, .printExpText ; if there's no EXP. all, show text normally
	ld a, [wWhichPokemon]
	and a ; Is this the first pokemon (the one currently out)
	jr z, .printExpText
	ld a, [wExpShareTextShown]
	and a
	jr nz, .skipExpText
	ld a, [wGainBoostedExp]
	and a ; Is this mon with no EXP?
	jr nz, .skipExpText
	ld a, 1
	ld [wExpShareTextShown], a
	ld hl, ExpAllGainedText
.printExpText
	call PrintText
.skipExpText
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	call AnimateEXPBar
	pop hl
	ld bc, wPartyMon1Level - wPartyMon1Exp
	add hl, bc
	push hl
	callba CalcLevelFromExperience
	pop hl
	ld a, [hl] ; current level
	ld [wTempLevel], a ; store current level
	cp d
	jp z, .nextMon ; if level didn't change, go to next mon
	call KeepEXPBarFull
	push af
	push hl
	ld a, d
	ld [wCurEnemyLVL], a
	ld [hl], a
	ld bc, wPartyMon1Species - wPartyMon1Level
	add hl, bc
	ld a, [hl] ; species
	ld [wd0b5], a
	ld [wd11e], a
	call GetMonHeader
	ld bc, (wPartyMon1MaxHP + 1) - wPartyMon1Species
	add hl, bc
	push hl
	ld a, [hld]
	ld c, a
	ld b, [hl]
	push bc ; push max HP (from before levelling up)
	ld d, h
	ld e, l
	ld bc, (wPartyMon1HPExp - 1) - wPartyMon1MaxHP
	add hl, bc
	ld b, $1 ; consider stat exp when calculating stats
	call CalcStats
	pop bc ; pop max HP (from before levelling up)
	pop hl
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a ; bc = difference between old max HP and new max HP after levelling
	ld de, (wPartyMon1HP + 1) - wPartyMon1MaxHP
	add hl, de
; add to the current HP the amount of max HP gained when levelling
	ld a, [hl] ; wPartyMon1HP + 1
	add c
	ld [hld], a
	ld a, [hl] ; wPartyMon1HP + 1
	adc b
	ld [hl], a ; wPartyMon1HP
	ld a, [wPlayerMonNumber]
	ld b, a
	ld a, [wWhichPokemon]
	cp b ; is the current mon in battle?
	jr nz, .printGrewLevelText
; current mon is in battle
	ld de, wBattleMonHP
; copy party mon HP to battle mon HP
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
; copy other stats from party mon to battle mon
	ld bc, wPartyMon1Level - (wPartyMon1HP + 1)
	add hl, bc
	push hl
	ld de, wBattleMonLevel
	ld bc, 1 + NUM_STATS * 2 ; size of stats
	call CopyData
	pop hl
	ld a, [wPlayerBattleStatus3]
	bit 3, a ; is the mon transformed?
	jr nz, .recalcStatChanges
; the mon is not transformed, so update the unmodified stats
	ld de, wPlayerMonUnmodifiedLevel
	ld bc, 1 + NUM_STATS * 2
	call CopyData
.recalcStatChanges
	xor a ; battle mon
	ld [wCalculateWhoseStats], a
	callab CalculateModifiedStats
	callab ApplyBurnAndParalysisPenaltiesToPlayer
	callab ApplyBadgeStatBoosts
	callab DrawPlayerHUDAndHPBar
	callab PrintEmptyString
	call SaveScreenTilesToBuffer1
.printGrewLevelText
	ld hl, GrewLevelText
	call PrintText
	xor a ;PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	call AnimateEXPBarAgain
	ld d, $1
	callab PrintStatsBox
	call WaitForTextScrollButtonPress
	call LoadScreenTilesFromBuffer1
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	ld a, [wd0b5]
	ld [wd11e], a
	
	ld a, [wCurEnemyLVL]
	ld c, a
	ld a, [wTempLevel]
	ld b, a
.level_loop
	inc b
	ld a, b
	ld [wCurEnemyLVL], a
	push bc
	predef LearnMoveFromLevelUp
	pop bc
	ld a, b
	cp c
	jr nz, .level_loop
	
	ld hl, wCanEvolveFlags
	ld a, [wWhichPokemon]
	ld c, a
	ld b, FLAG_SET
	predef FlagActionPredef
	pop hl
	pop af
	ld [wCurEnemyLVL], a

.nextMon
	ld a, [wPartyCount]
	ld b, a
	ld a, [wWhichPokemon]
	inc a
	cp b
	jr z, .done
	ld [wWhichPokemon], a
	ld bc, wPartyMon2 - wPartyMon1
	ld hl, wPartyMon1
	call AddNTimes
	jp .partyMonLoop
.done
	ld hl, wPartyGainExpFlags
	xor a
	ld [hl], a ; clear gain exp flags
	ld [wExpShareTextShown], a ; Clear wExpShareTextShown (not necissary, but a good idea)
	ld a, [wPlayerMonNumber]
	ld c, a
	ld b, FLAG_SET
	push bc
	predef FlagActionPredef ; set the gain exp flag for the mon that is currently out
	ld hl, wPartyFoughtCurrentEnemyFlags
	xor a
	ld [hl], a
	pop bc
	predef_jump FlagActionPredef ; set the fought current enemy flag for the mon that is currently out

; divide enemy base stats, catch rate, and base exp by the number of mons gaining exp
DivideExpDataByNumMonsGainingExp:
	ld a, [wPartyGainExpFlags]
	ld b, a
	xor a
	ld c, $8
	ld d, $0
.countSetBitsLoop ; loop to count set bits in wPartyGainExpFlags
	xor a
	srl b
	adc d
	ld d, a
	dec c
	jr nz, .countSetBitsLoop
	cp $2
	ret c ; return if only one mon is gaining exp
	ld [wd11e], a ; store number of mons gaining exp
	ld hl, wEnemyMonBaseStats
	ld c, wEnemyMonBaseExp + 1 - wEnemyMonBaseStats
.divideLoop
	xor a
	ld [H_DIVIDEND], a
	ld a, [hl]
	ld [H_DIVIDEND + 1], a
	ld a, [wd11e]
	ld [H_DIVISOR], a
	ld b, $2
	call Divide ; divide value by number of mons gaining exp
	ld a, [H_QUOTIENT + 3]
	ld [hli], a
	dec c
	jr nz, .divideLoop
	ret

; multiplies exp by 1.5
BoostExp:
	ld a, [H_QUOTIENT + 2]
	ld b, a
	ld a, [H_QUOTIENT + 3]
	ld c, a
	srl b
	rr c
	add c
	ld [H_QUOTIENT + 3], a
	ld a, [H_QUOTIENT + 2]
	adc b
	ld [H_QUOTIENT + 2], a
	ret

GainedText:
	TX_FAR _GainedText
	TX_ASM
	ld hl, ExpPointsText
	ld a, [wGainBoostedExp]
	and a
	ret z
	ld hl, BoostedText
	ret

ExpAllGainedText:
	TX_FAR _ExpAllGainedText
	TX_ASM
	ld hl, ExpAllPointsText
	ret 

WithExpAllText:
	TX_FAR _WithExpAllText
	db "@"

BoostedText:
	TX_FAR _BoostedText

ExpPointsText:
	TX_FAR _ExpPointsText
	db "@"

ExpAllPointsText:
	TX_FAR _ExpAllPointsText
	db "@"

GrewLevelText:
	TX_FAR _GrewLevelText
	TX_SFX_LEVEL_UP
	db "@"
