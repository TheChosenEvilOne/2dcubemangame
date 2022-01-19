/turf
	datum_flags = 0
	var/slowdown = 0
	var/atom/movable/lighting_overlay/lighting_overlay
	var/base_turf
	var/variation = 0
	var/base_state

/turf/New()
	. = ..()
	lighting_overlay = locate(/atom/movable/lighting_overlay) in src
	if (!lighting_overlay)
		lighting_overlay = new /atom/movable/lighting_overlay(src)
	if (variation && base_state)
		icon_state = "[base_state][rand(variation)]"

/turf/destroy()
	..()
	if (base_turf)
		new base_turf(src)
		return
	new world.turf(src)