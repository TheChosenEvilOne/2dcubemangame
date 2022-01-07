/obj/campfire
	name = "campfire"
	desc = "a nice warm campfire"
	icon_state = "campfire"
	density = 1
	light = 15
	datum_flags = DATUM_PROCESS
	processing_system = /system/processing/random

/obj/campfire/process()
	if (prob(1))
		act("crackles")