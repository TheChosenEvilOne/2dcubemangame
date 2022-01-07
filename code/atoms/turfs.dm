/turf
	icon = 'icons/turfs.dmi'
	datum_flags = 0
	var/atom/movable/lighting_overlay/lighting_overlay
	var/base_turf
	var/variation = 0
	var/base_state

/turf/New()
	. = ..()
	lighting_overlay = new /atom/movable/lighting_overlay(src)
	if (variation && base_state)
		icon_state = "[base_state][rand(variation)]"

/turf/Del()
	lighting_overlay.loc = null
	..()

/turf/destroy()
	..()
	lighting_overlay.loc = null
	if (base_turf)
		new base_turf(src)
		return
	new world.turf(src)

/turf/floor

/turf/wall
	name = "wall"
	icon_state = "wall"
	density = 1
	opacity = 1