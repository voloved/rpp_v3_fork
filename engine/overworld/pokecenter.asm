DisplayPokemonCenterDialogue_:
	call SaveScreenTilesToBuffer1 ; save screen
	ld hl, PokemonCenterWelcomeText
	call PrintText
	ld hl, wd72e
	bit 2, [hl]
	set 1, [hl]
	set 2, [hl]
	jr nz, .skipShallWeHealYourPokemon
.skipShallWeHealYourPokemon
	call SetLastBlackoutMap
	call LoadScreenTilesFromBuffer1 ; restore screen
	ld hl, NeedYourPokemonText
	call PrintText
	ld a, $18
	ld [wSpriteStateData1 + $12], a ; make the nurse turn to face the machine
	call Delay3
	predef HealParty
	callba AnimateHealingMachine ; do the healing machine animation
	xor a
	ld [wPokeVialUses], a
	ld [wAudioFadeOutControl], a
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, [wMapMusicSoundID]
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	call PlayMusic
	ld hl, PokemonFightingFitText
	call PrintText
	ld a, $14
	ld [wSpriteStateData1 + $12], a ; make the nurse bow
	ld c, a
	call DelayFrames
	jr .done
.declinedHealing
	call LoadScreenTilesFromBuffer1 ; restore screen
.done
	ld hl, PokemonCenterFarewellText
	call PrintText
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	jp UpdateSprites

PokemonCenterWelcomeText:
	TX_FAR _PokemonCenterWelcomeText
	db "@"

ShallWeHealYourPokemonText:
	TX_DELAY
	TX_FAR _ShallWeHealYourPokemonText
	db "@"

NeedYourPokemonText:
	TX_FAR _NeedYourPokemonText
	db "@"

PokemonFightingFitText:
	TX_FAR _PokemonFightingFitText
	db "@"

PokemonCenterFarewellText:
	TX_DELAY
	TX_FAR _PokemonCenterFarewellText
	db "@"
