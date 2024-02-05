/mob/dead/ghost
	name = "ghost"
	desc = "AAAAAAAAA!!"
	icon_state = "ghost"
	layer = OVER_LIGHTING_LAYER
	movement_type = FLYING
	can_interact = FALSE
	sight = SEE_THRU
	movement_delay = 0.5
	invisibility = 50
	see_invisible = 50

/mob/dead/ghost/update_name(N)
	name = "ghost of [N]"
	update_maptext()

/mob/dead/ghost/update_maptext()
	. = ..()
	maptext = CENTERTEXT(MAPTEXT("[key][client ? "" : " (DC)"]"))