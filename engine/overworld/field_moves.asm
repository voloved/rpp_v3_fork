; Copied pretty much verbatim from proof-of-concept code by Yenatch.
; Expanded by Mateo to work more like Gen 2, and to fix a bug with Cut requiring the wrong badge.
; Additional comments added by Mateo to clarify existing yenatch code and new Mateo code.
TryFieldMove:: ; predef
	call GetPredefRegisters

.Main:
	call TrySurf
	ret z
	call TryCut
	ret z
	call TryHeadbutt
	ret

TrySurf:
; Check if you are already surfing, and don't do anything if you are.
	ld a, [wWalkBikeSurfState]
	cp 2
	jr z, .no

; Check to make sure you are facing a surfable tile.
	call IsSurfTile
	jr nc, .no

; Check to make sure you aren't on top of a cliff or something.
	ld hl,TilePairCollisionsWater
	call CheckForTilePairCollisions2
	jr c, .no
	jr .yestho  ;DELETE WHEN TESTING IS DONE

; Check for a Pokemon in the party with SURF, and for the proper badge to use it.
	ld d, SURF
	call HasPartyMove
	jr z, .checkBadge
	call CanPartyLearnMove
	jr nz, .no
	ld b, HM_03
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr z, .no
.checkBadge
	ld a, [wObtainedKantoBadges]
	bit 4, a ; SOUL_BADGE
	jr z, .no
.yestho  ;DELETE WHEN TESTING IS DONE
; Are we allowed to surf here?
	call Text2_EnterTheText
	callba IsSurfingAllowed ; in current Pokered, this is callba IsSurfingAllowed
	ld hl,wd728
	bit 1,[hl]
	res 1,[hl]
	jr z,.no2

; Display "The water is calm. Do you want to SURF?" prompt like Gen 2 does.
	ld hl,WaterIsCalmTxt
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .no2

; Call the Surf routine if you said yes.
	call GetPartyMonName2
	ld a, SURFBOARD
	ld [wcf91], a
	ld [wPseudoItemID], a
	call UseItem
	call Text3_DrakesDeception

.yes
	xor a
	ret
	
.no2
	call Text3_DrakesDeception
.no
	ld a, 1
	and a
	ret

TryCut: ; yenatch's code originally checked for the SOUL_BADGE like SURF does by mistake.
	call IsCutTile
	jr nc, .no
	
	; Prints the "This tree can be cut!" message, whether you can CUT yet or not.
	call Text2_EnterTheText
	ld hl,CanBeCutTxt
	call PrintText
	call ManualTextScroll

	; Makes sure you have a Pokemon with CUT and have the proper badge.
	ld d, CUT
	call HasPartyMove
	jr z, .checkBadge
	call CanPartyLearnMove
	jr nz, .no2
	ld b, HM_01
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr z, .no2
.checkBadge
	ld a, [wObtainedKantoBadges]
	bit 1, a ; CASCADE_BADGE
	jr z, .no2

.yestho  ;DELETE WHEN TESTING IS DONE
	; Asks the player if they want to use CUT, the way Gen 2 does.
	ld hl,WantToCutTxt
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .no2

	; Calls the CUT routine if they said Yes.
	call GetPartyMonName2
	farcall Cut2
	call Text3_DrakesDeception

.yes
	xor a
	ret
	
.no2
	jr .yestho  ;DELETE WHEN TESTING IS DONE
	call Text3_DrakesDeception
.no
	ld a, 1
	and a
	ret

TryHeadbutt:
	call IsHeadbuttTile
	jr nc, .no
	
	; Makes sure you have a Pokemon with HEADBUTT.
	ld d, HEADBUTT
	call HasPartyMove
	jr z, .askToHeadbutt
	call CanPartyLearnMove
	jr nz, .no
	ld b, TM_34
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr z, .no
.askToHeadbutt
	; Prints the "A Pokemon might be hiding in this tree" message
	call Text2_EnterTheText
	ld hl,MightBeHiding
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .no2

	; Calls the HEADBUTT routine if they said Yes.
	call GetPartyMonName2
	farcall UseHeadbuttOW2
	call Text3_DrakesDeception

.yes
	xor a
	ret
	
.no2
	call Text3_DrakesDeception
.no
	ld a, 1
	and a
	ret

IsHeadbuttTile:
	ld a, [wCurMapTileset]
	and a ; OVERWORLD
	jr z, .overworld
	
	cp FOREST
	jr z, .forest
	
	cp PLATEAU
	jr z, .plateau
	
	jr .no
	
.plateau
	ld a, [wTileInFrontOfPlayer]
	cp $17
	jr z, .yes
	jr .no
	
.forest
	ld a, [wTileInFrontOfPlayer]
	cp $12
	jr z, .yes
	jr .no
	
.overworld
	ld a, [wTileInFrontOfPlayer]
	cp $50
	jr z, .yes
.no
	and a
	ret
.yes
	scf
	ret


IsSurfTile:
	ld a, [wCurMapTileset]
	ld hl, WaterTilesets2
	ld de,1
	call IsInArray
	jr nc, .no

	ld a, [wCurMapTileset]
	cp SHIP_PORT
	ld a, [wTileInFrontOfPlayer]
	jr z, .ok
	cp $48 ; east shore (safari zone)
	jr z, .yes
	cp $32 ; east shore
	jr z, .yes
.ok
	cp $14 ; water
	jr z, .yes
.no
	and a
	ret
.yes
	scf
	ret

; tilesets with water
; originally contained DOJO but that tileset does not exist in Red++
; just make sure this has all tilesets you want to surf in listed
WaterTilesets2: ; Renamed from what Yenatch called it, since that had overlap errors
	db OVERWORLD
	db FOREST
	db SAFARI ; New tileset in Red++
	db GYM
	db SHIP
	db SHIP_PORT
	db CAVERN
	db FACILITY
	db PLATEAU
	db ICE_CAVERN
	db -1

IsCutTile:
	ld a, [wCurMapTileset]
	and a ; OVERWORLD
	jr z, .overworld

	cp GYM
	jr z, .gym

	jr .no

.gym
	ld a, [wTileInFrontOfPlayer]
	cp $50 ; gym cut tree
	jr z, .yes
	jr .no

.overworld ; commented out options would let you run this when talking to tall grass if restored.
	ld a, [wTileInFrontOfPlayer]
	cp $3d ; cut tree
	jr z, .yes
;	cp $52 ; grass
;	jr z, .yes
;	jr .no

.no
	and a
	ret
.yes
	scf
	ret


HasPartyMove::
; Return z (optional: in wWhichTrade) if a PartyMon has move d.
; Updates wWhichPokemon.

	push bc
	push de
	push hl

	ld a, [wPartyCount]
	and a
	jr z, .no
	ld b, a
	ld c, 0
	ld hl, wPartyMons + (wPartyMon1Moves - wPartyMon1)
.loop
	ld e, NUM_MOVES
.check_move
	ld a, [hli]
	cp d
	jr z, .yes
	dec e
	jr nz, .check_move

	ld a, wPartyMon2 - wPartyMon1 - NUM_MOVES
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a

	inc c
	ld a, c
	cp b
	jr c, .loop
	jr .no

.yes
	ld a, c
	ld [wWhichPokemon], a
	xor a ; probably redundant
	ld [wWhichTrade], a
	jr .done
.no
	ld a, 1
	and a
	ld [wWhichTrade], a
.done
	pop hl
	pop de
	pop bc
	ret


CanPartyLearnMove::
; Return z (optional: in wWhichTrade) if a PartyMon can learn move d.
; Updates wWhichPokemon.
	push bc
	push de
	push hl
	ld a, d
	ld [wMoveNum], a
	ld a, [wPartyCount]
	and a
	jr z, .no
	ld e, a
	ld d, 0
	ld hl, wPartyMon1Species
.loop
	ld a, [hl]
	ld [wcf91],a
	push de
	predef CanLearnTM ; check if the pokemon can learn the move
	pop de
	ld a,c
	and a
	jr nz,.yes
	inc d
	ld a, d
	cp e
	jr z, .no
	ld hl, wPartyMon1Species
    ld bc, wPartyMon2 - wPartyMon1
    call AddNTimes
	jr .loop
.yes
	ld a, d
	ld [wWhichPokemon], a
	xor a ; probably redundant
	ld [wWhichTrade], a
	jr .done
.no
	ld a, 1
	and a
	ld [wWhichTrade], a
.done
	pop hl
	pop de
	pop bc
	ret

CutTreeLocations:
; first byte = The map the tree is on
; second byte = The Y coordinate of the block
; third byte = The X coordinate of the block
; fourth byte = Tree block without the tree in it
	db VIRIDIAN_CITY, 2, 7
	db VIRIDIAN_CITY, 11, 4
	db ROUTE_2, 11, 7
	db ROUTE_2, 30, 6
	db PEWTER_CITY, 9, 17
	db CERULEAN_CITY, 4, 11
	db CERULEAN_CITY, 4, 11
	db ROUTE_8, 4, 11
	db ROUTE_9, 4, 11
	db VERMILION_CITY, 9, 7
	db ROUTE_10, 4, 11
	db CELADON_CITY, 4, 11
	db ROUTE_13, 4, 11
	db ROUTE_14, 4, 11
	db ROUTE_14, 4, 11
	db ROUTE_16, 4, 11
	db ROUTE_25, 4, 11
	db $FF ; list terminator

FindCutTreeIdx:
	; d = Y loc
	; e = X loc
	; b = map loc
	; Output: c = current loop
	;         carry flag = set if found
	;         a = The new tile to use
	ld hl, CutTreeLocations
	ld c, 0
	jr .loopfirst
.loopinctwo
	inc hl
.loopincone
	inc hl
	inc c
.loopfirst ; find the matching tile block in the array
	ld a, [hl]
	inc hl
	cp $ff
	and a
	ret z ; Not in list; return with a cleared carry flag
	cp b ; Compare map
	jr nz, .loopinctwo
	ld a, [hl]  ; hl +1 (Y loc)
	inc hl
	cp d
	jr nz, .loopincone
	ld a, [hl]  ; hl +2 (X loc)
	cp e
	jr nz, .loopincone
	scf
	ret ; Found; return with set carry flag

SetCutTree::
	ld a, [wYCoord]
	sra a
	ld d, a ; d holds the Y block loc
	ld a, [wXCoord]
	sra a
	ld e, a ; e holds the X block loc
	ld a, [wSpriteStateData1 + 9] ; player sprite's facing direction
	and a
	jr z, .down
	cp SPRITE_FACING_UP
	jr z, .up
	cp SPRITE_FACING_LEFT
	jr z, .left
; right	
	ld a, [wXBlockCoord]
	and a
	jr z, .findMapLoc
	inc e
	jr .findMapLoc
.down
	ld a, [wYBlockCoord]
	and a
	jr z, .findMapLoc
	inc d
	jr .findMapLoc
.up
	ld a, [wYBlockCoord]
	and a
	jr nz, .findMapLoc
	dec d
	jr .findMapLoc
.left
	ld a, [wXBlockCoord]
	and a
	jr nz, .findMapLoc
	dec e
.findMapLoc
	ld a,[wCurMap]
	ld b, a
	call FindCutTreeIdx
	ret nc
	ld b, 1
	ld hl, wCutTrees
	ld a, c
	cp 8
	jr c, .setByte
	; second byte of wCutTrees
	sub 8
	inc hl
	ld c, a
.setByte
	predef FlagActionPredef
	ret

ClearCutTrees::
	; d = Y loc
	; e = X loc
	ld a,[wCurMap]
	ld b, a
	call FindCutTreeIdx
	ret nc
	ld hl, wCutTrees
	ld a, c
.iterByte
	cp 8
	jr c, .checkByte
	sub 8
	inc hl
	ld c, a
	jr .iterByte
.checkByte
	ld b, 2
	predef FlagActionPredef
	ld a, c
	and a
	ret z
	ld b, d
	ld c, e
	push bc
	predef FindTileBlock ; hl holds block ID at X,Y coord on the map
	ld a, [hl]
	ld [wNewTileBlockID], a
	farcall FindTileBlockReplacementCut
	pop bc
	predef_jump ReplaceTileBlock
	ret

Text2_EnterTheText: ; Gets everything setup to let you display text properly
	call EnableAutoTextBoxDrawing
	ld a, 1 ; not 0
	ld [hSpriteIndexOrTextID], a
	farcall DisplayTextIDInit
	ret

Text3_DrakesDeception: ; Closes the text out properly to prevent glitches
	ld a,[H_LOADEDROMBANK]
	push af
	jp CloseTextDisplay
	
CanBeCutTxt:
	text "This tree can be"
	line "Cut!@@"
	
WantToCutTxt:
	text "Would you like to"
	line "use Cut?@@"
	
WaterIsCalmTxt:
	text "The water is calm."
	line "Would you like to"
	cont "use Surf?@@"

MightBeHiding:
	text "A #mon might"
	line "be hiding in this"
	cont "tree."

	para "Want to use"
	line "Headbutt?@@"
