db DEX_ANNIHILAPE ; pokedex id
db 110 ; base hp
db 115 ; base attack
db 80 ; base defense
db 90 ; base speed
db 60 ; base special
db FIGHTING ; species type 1
db GHOST    ; species type 2
db 45 ; catch rate
db 199 ; base exp yield
INCBIN "pic/bmon/annihilape.pic",0,1 ; 77, sprite dimensions
dw AnnihilapePicFront
dw AnnihilapePicBack
; move tutor compatibility flags
	m_tutor 5,7,8
	m_tutor 9,10,11
	m_tutor 0
	m_tutor 0
db 0 ; growth rate
; learnset
	tmlearn 1,3,5,6,8
	tmlearn 9,10,15,16
	tmlearn 17,18,19,24
	tmlearn 25,26,27,28,30,31,32
	tmlearn 34,36,39,40
	tmlearn 41,43,44,48
	tmlearn 49,54
db BANK(AnnihilapePicFront)
