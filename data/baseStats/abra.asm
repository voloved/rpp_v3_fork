AbraBaseStats: ; 38aa6 (e:4aa6)
db DEX_ABRA ; pokedex id
db 25 ; base hp
db 20 ; base attack
db 15 ; base defense
db 90 ; base speed
db 105 ; base special
db PSYCHIC ; species type 1
db PSYCHIC ; species type 2
db 200 ; catch rate
db 73 ; base exp yield
INCBIN "pic/bmon/abra.pic",0,1 ; 55, sprite dimensions
dw AbraPicFront
dw AbraPicBack
; attacks known at lvl 0
db TELEPORT
db 0
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn 1,5,6
	tmlearn 9,10
	tmlearn 18,19,24
	tmlearn 29,30,32
	tmlearn 34,39,40
	tmlearn 42,43,44,45,46
	tmlearn 49,50
db BANK(AbraPicFront)
