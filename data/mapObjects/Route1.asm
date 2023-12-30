Route1Object:
	db $f ; border block

	db $0 ; warps

	db $1 ; signs
	db $1b, $9, $5 ; Route1Text3

	db $4 ; objects
	object SPRITE_BUG_CATCHER, $5, $18, WALK, $1, $1 ; person
	object SPRITE_BUG_CATCHER, $f, $d, WALK, $2, $2 ; person
	object SPRITE_BERRY_TREE, $6, $7, STAY, NONE, $3 ; person
	object SPRITE_OAK, $A, $19, STAY, NONE, $4 ; oak

	; warp-to (unused)
	EVENT_DISP $4, $7, $2
