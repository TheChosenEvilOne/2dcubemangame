/turf
	icon = 'icons/turfs.dmi'
	var/base_turf
	var/variation = 0
	var/base_state

/turf/New()
	. = ..()
	if (variation && base_state)
		icon_state = "[base_state][rand(variation)]"

/turf/destroy()
	if (base_turf)
		new base_turf(src)
	else
		del src

/turf/floor

/turf/wall
	name = "wall"
	icon_state = "wall"
	density = 1
	opacity = 1