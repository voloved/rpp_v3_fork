VermilionDockScript:
	call EnableAutoTextBoxDrawing
	ld a, [wSSAnne10CurScript] ; Reusing wSSAnne10CurScript; but it should always finish with it at 0
	ld hl, VermilionDockScriptPointers
	jp CallFunctionInTable

VermilionDocksScript0:
	CheckEventHL EVENT_STARTED_WALKING_OUT_OF_DOCK
	jr nz, .asm_1db8d
	CheckEventReuseHL EVENT_GOT_HM01
;	ret z
	ld a, [wDestinationWarpID]
	cp $1
	ret nz
	CheckEventReuseHL EVENT_SS_ANNE_LEFT
	jp z, VermilionDock_1db9b
	SetEventReuseHL EVENT_STARTED_WALKING_OUT_OF_DOCK
	call Delay3
	ld hl, wd730
	set 7, [hl]
	ld hl, wSimulatedJoypadStatesEnd
	ld a, D_UP
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $3
	ld [wSimulatedJoypadStatesIndex], a
	xor a
	ld [wSpriteStateData2 + $06], a
	ld [wOverrideSimulatedJoypadStatesMask], a
	dec a
	ld [wJoyIgnore], a
	ret
.asm_1db8d
	CheckEventAfterBranchReuseHL EVENT_WALKED_OUT_OF_DOCK, EVENT_STARTED_WALKING_OUT_OF_DOCK
	ret nz
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld [wJoyIgnore], a
	SetEventReuseHL EVENT_WALKED_OUT_OF_DOCK
	ret

VermilionDock_1db9b:
	SetEventForceReuseHL EVENT_SS_ANNE_LEFT
	ld a, $ff
	ld [wJoyIgnore], a
	ld [wNewSoundID], a
	call PlaySound
	ld c, 0 ; BANK(Music_Surfing)
	ld a, MUSIC_SURFING
	call PlayMusic
	callba LoadSmokeTileFourTimes
	xor a
	ld [wSpriteStateData1 + 2], a
	ld c, 120
	call DelayFrames
	ld b, $9c
	call CopyScreenTileBufferToVRAM
	coord hl, 0, 10
	ld bc, SCREEN_WIDTH * 6
	ld a, $14 ; water tile
	call FillMemory
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [wSSAnneSmokeDriftAmount], a
	ld [rOBP1], a
	ld a, 88
	ld [wSSAnneSmokeX], a
	ld hl, wMapViewVRAMPointer
	ld c, [hl]
	inc hl
	ld b, [hl]
	push bc
	push hl
	ld a, SFX_SS_ANNE_HORN
	call PlaySoundWaitForCurrent
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld d, $0
	ld e, $8
.asm_1dbfa
	ld hl, $0002
	add hl, bc
	ld a, l
	ld [wMapViewVRAMPointer], a
	ld a, h
	ld [wMapViewVRAMPointer + 1], a
	push hl
	push de
	call ScheduleEastColumnRedraw
	call VermilionDock_EmitSmokePuff
	pop de
	ld b, $10
.asm_1dc11
	call VermilionDock_AnimSmokePuffDriftRight
	ld c, $8
.asm_1dc16
	call VermilionDock_1dc7c
	dec c
	jr nz, .asm_1dc16
	inc d
	dec b
	jr nz, .asm_1dc11
	pop bc
	dec e
	jr nz, .asm_1dbfa
	xor a
	ld [rWY], a
	ld [hWY], a
	call VermilionDock_EraseSSAnne
	ld a, $90
	ld [hWY], a
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	pop hl
	pop bc
	ld [hl], b
	dec hl
	ld [hl], c
	call LoadPlayerSpriteGraphics
	ld hl, wNumberOfWarps
	dec [hl]
	ret

VermilionDock_AnimSmokePuffDriftRight:
	push bc
	push de
	ld hl, wOAMBuffer + $11
	ld a, [wSSAnneSmokeDriftAmount]
	swap a
	ld c, a
	ld de, 4
.loop
	inc [hl]
	inc [hl]
	add hl, de
	dec c
	jr nz, .loop
	pop de
	pop bc
	ret

VermilionDock_EmitSmokePuff:
; new smoke puff above the S.S. Anne's front smokestack
	ld a, [wSSAnneSmokeX]
	sub 16
	ld [wSSAnneSmokeX], a
	ld c, a
	ld b, 100 ; Y
	ld a, [wSSAnneSmokeDriftAmount]
	inc a
	ld [wSSAnneSmokeDriftAmount], a
	ld a, $1
	ld de, VermilionDockOAMBlock
	call WriteOAMBlock
	ret

VermilionDockOAMBlock:
	db $fc, $13
	db $fd, $13
	db $fe, $13
	db $ff, $13

VermilionDock_1dc7c:
	ld h, d
	ld l, $50
	call .asm_1dc86
	ld h, $0
	ld l, $80
.asm_1dc86
	ld a, [rLY]
	cp l
	jr nz, .asm_1dc86
	ld a, h
	ld [rSCX], a
.asm_1dc8e
	ld a, [rLY]
	cp h
	jr z, .asm_1dc8e
	ret

VermilionDock_EraseSSAnne:
; Fill the area the S.S. Anne occupies in BG map 0 with water tiles.
; HAX: call another function to do this (also updates palettes).
	CALL_INDIRECT EraseSSAnneWithColor

; Padding to prevent data shifting
rept 17
	nop
endr

; Replace the blocks of the lower half of the ship with water blocks. This
; leaves the upper half alone, but that doesn't matter because replacing any of
; the blocks is unnecessary because the blocks the ship occupies are south of
; the player and won't be redrawn when the player automatically walks north and
; exits the map. This code could be removed without affecting anything.
	overworldMapCoord hl, 5, 2, VERMILION_DOCK_WIDTH
	ld a, $d ; water block
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a

	ld a, SFX_SS_ANNE_HORN
	call PlaySound
	ld c, 120
	call DelayFrames
	ret

VermilionDockTextPointers:
	dw VermilionTruck1
	dw VermilionTruck1

VermilionDockText1:
	TX_FAR _VermilionDockText1
	db "@"

VermilionDockText2:
	TX_FAR _VermilionDockText2
	db "@"

VermilionDockText3:
	TX_FAR _VermilionDockText3
	db "@"

VermilionDockScriptPointers:
	dw VermilionDocksScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw VermilionDocksScript3

VermilionTruck1:
	TX_ASM
	ld hl, VermilionDockText1
	call PrintText	
	CheckEvent EVENT_BEAT_MEW
	jr nz, .alreadyBattled
	ld hl, VermilionDockText3
	call PrintText
	ld a, MEW
	ld [wCurOpponent], a
	call PlayCry ; play Pokémon cry
	ld a, [wPartyMon1Level]
	ld [wCurEnemyLVL], a
	xor a
	ld [wIsTrainerBattle], a ; wild battle
	call WaitForSoundToFinish
	ld a, $3
	ld [wSSAnne10CurScript], a
	jp TextScriptEnd
.alreadyBattled
	ld hl, VermilionDockText2
	call PrintText
	call ResetToScript0
	jp TextScriptEnd

VermilionDocksScript3:
	ld a, [wIsInBattle]
	cp $ff ; lost battle
	jp z, ResetToScript0
	SetEvent EVENT_BEAT_MEW

ResetToScript0:
	xor a
	ld [wSSAnne10CurScript], a
	ret

ShipTileSwapArray:
; first byte = The Y coordinate of the block
; second byte = The X coordinate of the block
; third byte = Block to replace
	db 1, 5, $01
	db 1, 6, $0D
	db 1, 7, $17
	db 1, 8, $01
	db 2, 5, $0D
	db 2, 6, $0D
	db 2, 7, $0D
	db 2, 8, $0D
	db $FF ; list terminator


RemoveSSAnne:
	ld a, [wCurMap]
	cp VERMILION_DOCK
	ret nz
	CheckEvent EVENT_SS_ANNE_LEFT
	ret z
	ld de, ShipTileSwapArray
.loop
	ld a, [de]
	cp $ff
	jr z, .done
	ld b, a
	inc de
	ld a, [de]
	ld c, a
	inc de
	push de
	predef FindTileBlock
	pop de
	ld a, [de]
	inc de
	ld [hl], a
	jr .loop
.done
	ret