_KogaExplainToxicText::
	text "When afflicted by"
	line "Toxic, #mon"
	cont "suffer more and"
	cont "more as battle"
	cont "progresses!"

	para "It will surely"
	line "terrorize foes!"
	done

_FuchsiaGymText9::
IF DEF(_HARD)
	text "Ah! Take this"
	line "too!"
ELSE
	text "Now that you have"
	line "the SoulBadge,"
	cont "the Defense of"
	cont "your #mon"
	cont "increases!"
	para "Ah! Take this"
	line "too!"
ENDC
	done

_ReceivedTM06Text::
	text "[PLAYER] received"
	line "@"
	TX_RAM wcf4b
	text "!@@"

_TM06ExplanationText::
	db $0
	para "TM06 contains"
	line "Toxic!"

	para "It is a secret"
	line "technique over"
	cont "400 years old!"
	done

_TM06NoRoomText::
	text "Make space for"
	line "this, child!"
	done

_FuchsiaGymBattleText1::
	text "Strength isn't"
	line "the key for"
	cont "#mon!"

	para "It's strategy!"

	para "I'll show you how"
	line "strategy can beat"
	cont "brute strength!"
	done

_FuchsiaGymEndBattleText1::
	text "What?"
	line "Extraordinary!"
	prompt

_FuchsiaGymAfterBattleText1::
	text "So, you mix brawn"
	line "with brains?"
	cont "Good strategy!"
	done

_FuchsiaGymBattleText2::
	text "I wanted to become"
	line "a ninja, so I"
	cont "joined this Gym!"
	done

_FuchsiaGymEndBattleText2::
	text "I'm done for!"
	prompt

_FuchsiaGymAfterBattleText2::
	text "I will keep on"
	line "training under"
	cont "Koga, my ninja"
	cont "master!"
	done

_FuchsiaGymBattleText3::
	text "Let's see you"
	line "beat my special"
	cont "techniques!"
	done

_FuchsiaGymEndBattleText3::
	text "You had me"
	line "fooled!"
	prompt

_FuchsiaGymAfterBattleText3::
	text "I like poison and"
	line "sleep techniques,"
	cont "as they linger"
	cont "after battle!"
	done

_FuchsiaGymBattleText4::
	text "Stop right there!"

	para "Our invisible"
	line "walls have you"
	cont "frustrated?"
	done

_FuchsiaGymEndBattleText4::
	text "Whoa!"
	line "You've got it!"
	prompt

_FuchsiaGymAfterBattleText4::
	text "You impressed me!"
	line "Here's a hint!"

	para "Look very closely"
	line "for gaps in the"
	cont "invisible walls!"
	done

_FuchsiaGymBattleText5::
	text "I also study the"
	line "way of the ninja"
	cont "with master Koga!"

	para "Ninja have a long"
	line "history of using"
	cont "animals!"
	done

_FuchsiaGymEndBattleText5::
	text "Awoo!"
	prompt

_FuchsiaGymAfterBattleText5::
	text "I still have much"
	line "to learn!"
	done

_FuchsiaGymBattleText6::
	text "Master Koga comes"
	line "from a long line"
	cont "of ninjas!"

	para "What did you"
	line "descend from?"
	done

_FuchsiaGymEndBattleText6::
	text "Dropped my balls!"
	prompt

_FuchsiaGymAfterBattleText6::
	text "Where there is"
	line "light, there is"
	cont "shadow!"

	para "Light and shadow!"
	line "Which do you"
	cont "choose?"
	done

_FuchsiaGymText_7564e::
	text "Yo! Champ in"
	line "making!"

	para "Fuchsia Gym is"
	line "riddled with"
	cont "invisible walls!"

	para "Koga might appear"
	line "close, but he's"
	cont "blocked off!"

	para "You have to find"
	line "gaps in the walls"
	cont "to reach him!"
	done

_FuchsiaGymText_75653::
	text "It's amazing how"
	line "ninja can terrify"
	cont "even now!"
	done
