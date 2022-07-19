/atom
	parent_type = /datum/game_object
	plane = WORLD_PLANE
	var/light = 0
	var/integrity
	var/max_integrity = 100
	var/rotatable = FALSE
	var/list/managed_overlays

/atom/initialize(start)
	. = ..()
	update_appearance()
	update_light()
	integrity = max_integrity

/atom/destroy()
	if (light)
		sys_light.remove_light(src)
	. = ..()

/atom/proc/bump(thing)
	return density

/atom/proc/update_light()
	if (opacity)
		set_opacity(opacity)
	if (!light)
		return
	sys_light.add_light(src)

/atom/proc/update_appearance()
	appearance_flags |= PIXEL_SCALE|LONG_GLIDE
	update_overlays()

/atom/proc/update_overlays()
	overlays.Cut()
	for (var/O in managed_overlays)
		overlays += managed_overlays[O]

/atom/proc/add_managed_overlay(name, image)
	managed_overlays[name] = image
	overlays += image

/atom/proc/remove_managed_overlay(name)
	var/img = managed_overlays[name]
	if (!img)
		return
	managed_overlays.Remove(name)
	if (!overlays.Remove(img))
		update_overlays()

/atom/proc/take_damage(amount)
	integrity -= amount
	if (integrity <= 0)
		destroy()

/atom/proc/heal_damage(amount)
	if(integrity + amount > max_integrity)
		integrity = max_integrity
		return
	integrity += amount

/atom/proc/projectile_impact(atom/movable/projectile/P)
	take_damage(P.damage)

/atom/proc/set_opacity(O)
	opacity = O

/atom/proc/set_density(D)
	density = D

/atom/movable
	vis_flags = VIS_INHERIT_PLANE
	var/unmovable = FALSE
	var/say_verb = "states"

/atom/movable/destroy()
	. = ..()
	loc = null

/atom/movable/Move()
	if (unmovable)
		return FALSE
	. = ..()

/atom/movable/proc/p_reflexive()
	switch (gender)
		if ("neuter") . = "itself"
		if ("male") . = "himself"
		if ("female") . = "herself"
		if ("plural") . = "themselves"

/atom/movable/proc/p_possessive()
	switch (gender)
		if ("neuter") . = "it's"
		if ("male") . = "his"
		if ("female") . = "hers"
		if ("plural") . = "theirs"

/atom/movable/proc/say(words)
	viewers() << "<b>[src]</b> [say_verb], \"[words]\""
	new /atom/movable/abstract/chat_message(src, words)

/atom/movable/proc/act(action)
	viewers() << "<i><b>[src]</b> [action]</i>"
	new /atom/movable/abstract/chat_message(src, "<i>[action]</i>")

/atom/movable/set_opacity(O)
	. = ..()
	if (isturf(loc))
		var/turf/T = loc
		T.update_lighting(O)

/atom/movable/set_density(D)
	. = ..()
