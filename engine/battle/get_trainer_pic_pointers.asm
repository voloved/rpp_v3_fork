LoadTrainerPicPointer:: ; New function to load the pointer for the trainer's pic
	ld a, [wLinkState]
	and a
	ld a, PLAYER_M
	jr nz, .linkBattle ; If it is a link battle, skip checking wTrainerPicID and load Red's sprite
	ld a, [wTrainerPicID]
.linkBattle
	dec a
	ld hl, TrainerPicPointers
	ld bc, $3 ; length of each entry
	call AddNTimes
	ld de, wTrainerPicBank
	ld a, [hli] ; get pic bank
	ld [de], a
	inc de
	ld a, [hli] ; get first byte of pointer
	ld [de], a
	inc de
	ld a, [hl] ; get last byte of pointer
	ld [de], a
	ret



TrainerPicPointers:
	add_pic YoungsterPic
	add_pic BugCatcherPic
	add_pic LassPic
	add_pic SailorPic
	add_pic JrTrainerMPic
	add_pic JrTrainerFPic
	add_pic PokemaniacPic
	add_pic SuperNerdPic
	add_pic HikerPic
	add_pic BikerPic
	add_pic BurglarPic
	add_pic EngineerPic
	add_pic YoungCouplePic
	add_pic FisherPic
	add_pic SwimmerPic
	add_pic CueBallPic
	add_pic GamblerPic
	add_pic BeautyPic
	add_pic PsychicPic
	add_pic RockerPic
	add_pic JugglerPic
	add_pic TamerPic
	add_pic BirdKeeperPic
	add_pic BlackbeltPic
	add_pic Rival1Pic
	add_pic SwimmerFPic
	add_pic RocketFPic
	add_pic ScientistPic
	add_pic GiovanniPic
	add_pic RocketPic
	add_pic CooltrainerMPic
	add_pic CooltrainerFPic
	add_pic BrunoPic
	add_pic BrockPic
	add_pic MistyPic
	add_pic LtSurgePic
	add_pic ErikaPic
	add_pic KogaPic
	add_pic BlainePic
	add_pic SabrinaPic
	add_pic GentlemanPic
	add_pic Rival2Pic
	add_pic Rival3Pic
	add_pic LoreleiPic
	add_pic ChannelerPic
	add_pic AgathaPic
	add_pic LancePic
	add_pic HexManiacPic
	add_pic RedPicFront ; placeholder, pic is loaded manually in trainer data
	add_pic ProfOakPic
	add_pic TraceyPic
	add_pic ExecutiveFPic
	add_pic ExecutiveMPic
	add_pic RockerFPic
	add_pic JessieJamesPic
	add_pic CosplayGirlPic
	add_pic JaninePic
	add_pic RedPicFront
	add_pic LeafPicFront
	add_pic PiTrainerPic
	add_pic FlanneryPic
	add_pic JessiePic
	add_pic JamesPic
	add_pic GiovanniGymPic
