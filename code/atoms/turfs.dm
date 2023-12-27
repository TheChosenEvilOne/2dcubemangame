/turf
	datum_flags = 0
	vis_flags = VIS_INHERIT_PLANE | VIS_UNDERLAY
	plane = TURF_PLANE
	var/slowdown = 0
	var/atom/movable/abstract/lighting_overlay/lighting_overlay
	var/base_turf
	var/variation = 0
	var/base_state
	var/walk_sound

/turf/New(atom/old)
	lighting_overlay = locate(/atom/movable/abstract/lighting_overlay) in src
	if (!lighting_overlay)
		lighting_overlay = new /atom/movable/abstract/lighting_overlay(src)
	if (old)
		if (old.opacity != opacity) update_lighting(opacity)
		if (old.datum_flags & DATUM_PROCESSING && (datum_flags & DATUM_PROCESSING && old.processing_system != processing_system))
			master.systems[processing_system].stop_processing(src)
	if (variation && base_state)
		icon_state = "[base_state][rand(variation)]"
	if (old.datum_flags & DATUM_PROCESSING
		)
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

/turf/bump(thing)
	var/ret = density
	for (var/atom/A as anything in contents)
		ret = A.bump(thing) ? TRUE : ret
	return ret

/turf/proc/enter(atom/movable/thing)
	return thing.loc = src