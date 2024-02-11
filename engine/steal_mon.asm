; bit 0: Starter
; bit 1: Pidgey Line
; bit 2: Rattata Line
; bit 3: Abra Line
; bit 4: Growlithe Line
; bit 5: Execute Line
; bit 6: Gyarados
; bit 7: Rhyhorn

SetStolen::
; wcf91 holds the species info
	ld a, [wTrainerClass]
	cp SONY1
	jr z, .isRival
	cp SONY2
	jr z, .isRival
	cp SONY3
	jr z, .isRival
	ret
.isRival
	ld a, [wRivalPokemonStolen]
	ld b, a
	ld a, [wcf91]
.checkStarter
	cp BULBASAUR
	jr c, .checkPidgey
	cp BLASTOISE
	jr z, .stoleStarter
	jr nc, .checkPidgey
	jr .stoleStarter
.checkPidgey
	cp PIDGEY
	jr c, .checkRattata
	cp PIDGEOT
	jr z, .stolePidgey
	jr nc, .checkRattata
	jr .stolePidgey
.checkRattata
	cp RATTATA
	jr z, .stoleRattata
	cp RATICATE
	jr z, .stoleRattata
.checkAbra
	cp ABRA
	jr c, .checkGrowlithe
	cp ALAKAZAM
	jr z, .stoleAbra
	jr nc, .checkGrowlithe
	jr .stoleAbra
.checkGrowlithe
	cp GROWLITHE
	jr z, .stoleGrowlithe
	cp ARCANINE
	jr z, .stoleGrowlithe
.checkExeggcute
	cp EXEGGCUTE
	jr z, .stoleExeggcute
	cp EXEGGUTOR
	jr z, .stoleExeggcute
.checkGyarados
	cp GYARADOS
	jr z, .stoleGyarados
.checkRhyhorn
	cp RHYHORN
	jr nz, .stoleRhyhorn
	ret
.stoleStarter
	ld a, b
	set 0, a
	jr .done
.stolePidgey
	ld a, b
	set 1, a
	jr .done
.stoleRattata
	ld a, b
	set 2, a
	jr .done
.stoleAbra
	ld a, b
	set 3, a
	jr .done
.stoleGrowlithe
	ld a, b
	set 4, a
	jr .done
.stoleExeggcute
	ld a, b
	set 5, a
	jr .done
.stoleGyarados
	ld a, b
	set 6, a
	jr .done
.stoleRhyhorn
	ld a, b
	set 7, a
	jr .done
.done
	ld [wRivalPokemonStolen], a
	ret

CheckStolen::
; wcf91 holds the species info
	ld a, [wTrainerClass]
	cp SONY1
	jr z, .isRival
	cp SONY2
	jr z, .isRival
	cp SONY3
	jr z, .isRival
	jr .notStolen
.isRival
	ld a, [wRivalPokemonStolen]
	ld b, a
	ld a, [wcf91]
.checkStarter
	bit 0, b
	jr z, .checkPidgey
	cp BULBASAUR ; Pointless b/c you can't be under Bulbasaur, but w/e
	jr c, .checkPidgey
	cp BLASTOISE
	jr z, .stolen
	jr nc, .checkPidgey
	jr .stolen
.checkPidgey
	bit 1, b
	jr z, .checkRattata
	cp PIDGEY
	jr c, .checkRattata
	cp PIDGEOT
	jr z, .stolen
	jr nc, .checkRattata
	jr .stolen
.checkRattata
	bit 2, b
	jr z, .checkAbra
	cp RATTATA
	jr z, .stolen
	cp RATICATE
	jr z, .stolen
.checkAbra
	bit 3, b
	jr z, .checkGrowlithe
	cp ABRA
	jr c, .checkGrowlithe
	cp ALAKAZAM
	jr z, .stolen
	jr nc, .checkGrowlithe
	jr .stolen
.checkGrowlithe
	bit 4, b
	jr z, .checkExeggcute
	cp GROWLITHE
	jr z, .stolen
	cp ARCANINE
	jr z, .stolen
.checkExeggcute
	bit 5, b
	jr z, .checkGyarados
	cp EXEGGCUTE
	jr z, .stolen
	cp EXEGGUTOR
	jr z, .stolen
.checkGyarados
	bit 6, b
	jr z, .checkRhyhorn
	cp GYARADOS
	jr z, .stolen
.checkRhyhorn
	bit 7, b
	jr z, .notStolen
	cp RHYHORN
	jr nz, .stolen
.notStolen
	and a
	ret
.stolen
	scf
	ret
