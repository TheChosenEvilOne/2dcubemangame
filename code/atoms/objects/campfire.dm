/obj/campfire
	name = "campfire"
	desc = "a nice warm campfire"
	icon_state = "campfire"
	density = TRUE
	light = 15
	datum_flags = DATUM_PROCESS
	processing_system = /system/processing/random
	var/heal_amount = 1

/obj/campfire/process()
	if(prob(25))
		act("crackles")
	for(var/mob/living/mob in range(2, src))
		mob.heal_damage(heal_amount)