/turf
	datum_flags = 0
	vis_flags = VIS_INHERIT_PLANE | VIS_UNDERLAY
	var/slowdown = 0
	var/atom/movable/abstract/lighting_overlay/lighting_overlay
	var/base_turf
	var/variation = 0
	var/base_state

/turf/New()
	lighting_overlay = locate(/atom/movable/abstract/lighting_overlay) in src
	if (!lighting_overlay)
		lighting_overlay = new /atom/movable/abstract/lighting_overlay(src)
	update_lighting(opacity)
	if (variation && base_state)
		icon_state = "[base_state][rand(variation)]"
	. = ..()

/turf/destroy()
	..()
	if (base_turf)
		new base_turf(src)
		return
	new world.turf(src)

/turf/proc/update_lighting(O)
	for (var/atom/A as anything in lighting_overlay.sources)
		sys_light.remove_light(A)
		sys_light.add_light(A)
