PlayerPC:
	ld hl, wd730
	set 6, [hl]
	ld a, ITEM_NAME
	ld [wNameListType], a
	call SaveScreenTilesToBuffer1
	xor a
	ld [wBagSavedMenuItem], a
	ld [wParentMenuItem], a
	ld a, [wFlags_0xcd60]
	bit 3, a ; accessing player's PC through another PC?
	jr nz, PlayerPCMenu
; accessing it directly
	ld a, SFX_TURN_ON_PC
	call PlaySound
	ld hl, TurnedOnPC2Text
	call PrintText

PlayerPCMenu:
	ld a, [wParentMenuItem]
	ld [wCurrentMenuItem], a
	ld hl, wFlags_0xcd60
	set 5, [hl]
	call LoadScreenTilesFromBuffer2
	coord hl, 0, 0
	ld b, $8
	ld c, $e
	call TextBoxBorder
	call UpdateSprites
	coord hl, 2, 2
	ld de, PlayersPCMenuEntries
	call PlaceString
	ld hl, wTopMenuItemY
	ld a, 2
	ld [hli], a ; wTopMenuItemY
	dec a
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, 3
	ld [hli], a ; wMaxMenuItem
	ld a, A_BUTTON | B_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hl], a
	ld hl, wListScrollOffset
	ld [hli], a ; wListScrollOffset
	ld [hl], a ; wMenuWatchMovingOutOfBounds
	ld [wPlayerMonNumber], a
	ld hl, WhatDoYouWantText
	call PrintText
	call HandleMenuInput
	bit 1, a
	jp nz, ExitPlayerPC
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	ld [wParentMenuItem], a
	and a
	jp z, PlayerPCWithdraw
	dec a
	jp z, PlayerPCDeposit
	dec a
	jp z, PlayerPCToss

ExitPlayerPC:
	ld a, [wFlags_0xcd60]
	bit 3, a ; accessing player's PC through another PC?
	jr nz, .next
; accessing it directly
	ld a, SFX_TURN_OFF_PC
	call PlaySound
	call WaitForSoundToFinish
.next
	ld hl, wFlags_0xcd60
	res 5, [hl]
	call LoadScreenTilesFromBuffer2
	xor a
	ld [wListScrollOffset], a
	ld [wBagSavedMenuItem], a
	ld hl, wd730
	res 6, [hl]
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret

PlayerPCDeposit:
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld a, [wNumBagItems]
	and a
	jr nz, .loop
	ld hl, NothingToDepositText
	call PrintText
	jp PlayerPCMenu
.loop
	ld hl, WhatToDepositText
	call PrintText
	ld hl, wNumBagItems
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	call DisplayListMenuID
	jp c, PlayerPCMenu
	call IsKeyItem
	ld a, 1
	ld [wItemQuantity], a
	ld a, [wIsKeyItem]
	and a
	jr nz, .next
; if it's not a key item, there can be more than one of the item
	ld hl, DepositHowManyText
	call PrintText
	call DisplayChooseQuantityMenu
	cp $ff
	jp z, .loop
.next
	ld hl, wNumBoxItems
	call AddItemToInventory
	jr c, .roomAvailable
	ld hl, NoRoomToStoreText
	call PrintText
	jp .loop
.roomAvailable
	ld a, [wcf91]
	cp CLEANSE_TAG
	jr nz, .notCleanseTag
	ld hl,wd736
	res 5, [hl]
.notCleanseTag
	ld hl, wNumBagItems
	call RemoveItemFromInventory
	call WaitForSoundToFinish
	ld a, SFX_WITHDRAW_DEPOSIT
	call PlaySound
	call WaitForSoundToFinish
	ld hl, ItemWasStoredText
	call PrintText
	jp .loop

PlayerPCWithdraw:
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld a, [wNumBoxItems]
	and a
	jr nz, .loop
	ld hl, NothingStoredText
	call PrintText
	jp PlayerPCMenu
.loop
	ld hl, WhatToWithdrawText
	call PrintText
	ld hl, wNumBoxItems
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	call DisplayListMenuID
	jp c, PlayerPCMenu
	call IsKeyItem
	ld a, 1
	ld [wItemQuantity], a
	ld a, [wIsKeyItem]
	and a
	jr nz, .next
; if it's not a key item, there can be more than one of the item
	ld hl, WithdrawHowManyText
	call PrintText
	call DisplayChooseQuantityMenu
	cp $ff
	jp z, .loop
.next
	ld hl, wNumBagItems
	call AddItemToInventory
	jr c, .roomAvailable
	ld hl, CantCarryMoreText
	call PrintText
	jp .loop
.roomAvailable
	ld hl, wNumBoxItems
	call RemoveItemFromInventory
	call WaitForSoundToFinish
	ld a, SFX_WITHDRAW_DEPOSIT
	call PlaySound
	call WaitForSoundToFinish
	ld hl, WithdrewItemText
	call PrintText
	jp .loop

PlayerPCToss:
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld a, [wNumBoxItems]
	and a
	jr nz, .loop
	ld hl, NothingStoredText
	call PrintText
	jp PlayerPCMenu
.loop
	ld hl, WhatToTossText
	call PrintText
	ld hl, wNumBoxItems
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	push hl
	call DisplayListMenuID
	pop hl
	jp c, PlayerPCMenu
	push hl
	call IsKeyItem
	pop hl
	ld a, 1
	ld [wItemQuantity], a
	ld a, [wIsKeyItem]
	and a
	jr nz, .next
	ld a, [wcf91]
	call IsItemHM
	jr c, .next
; if it's not a key item, there can be more than one of the item
	push hl
	ld hl, TossHowManyText
	call PrintText
	call DisplayChooseQuantityMenu
	pop hl
	cp $ff
	jp z, .loop
.next
	call TossItem ; disallows tossing key items
	jp .loop

PlayersPCMenuEntries:
	db   "Withdraw Item"
	next "Deposit Item"
	next "Toss Item"
	next "Log off@"

TurnedOnPC2Text:
	TX_FAR _TurnedOnPC2Text
	db "@"

WhatDoYouWantText:
	TX_FAR _WhatDoYouWantText
	db "@"

WhatToDepositText:
	TX_FAR _WhatToDepositText
	db "@"

DepositHowManyText:
	TX_FAR _DepositHowManyText
	db "@"

ItemWasStoredText:
	TX_FAR _ItemWasStoredText
	db "@"

NothingToDepositText:
	TX_FAR _NothingToDepositText
	db "@"

NoRoomToStoreText:
	TX_FAR _NoRoomToStoreText
	db "@"

WhatToWithdrawText:
	TX_FAR _WhatToWithdrawText
	db "@"

WithdrawHowManyText:
	TX_FAR _WithdrawHowManyText
	db "@"

WithdrewItemText:
	TX_FAR _WithdrewItemText
	db "@"

NothingStoredText:
	TX_FAR _NothingStoredText
	db "@"

CantCarryMoreText:
	TX_FAR _CantCarryMoreText
	db "@"

WhatToTossText:
	TX_FAR _WhatToTossText
	db "@"

TossHowManyText:
	TX_FAR _TossHowManyText
	db "@"
