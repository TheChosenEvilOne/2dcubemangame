/atom
	parent_type = /datum/game_object
	plane = WORLD_PLANE
	var/light = 0
	var/integrity
	var/max_integrity = 100
	var/rotatable = FALSE

/atom/initialize(start)
	. = ..()
	update_appearance()
	update_light()
	integrity = max_integrity

/atom/destroy()
	if (light)
		sys_light.propagate_light(src, sys_light.ambient_light[min(sys_light.ambient_light.len, z)])

/atom/proc/update_light()
	if (!light) // XXX: remove sys_light check once initialisation priority is fixed
		return
	sys_light.propagate_light(src, light)

/atom/proc/update_appearance()
	appearance_flags |= PIXEL_SCALE

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

/atom/movable
	var/say_verb = "states"

/atom/movable/destroy()
	..()
	loc = null

/atom/movable/proc/p_possessive()
	switch (gender)
		if ("neuter") . = "itself"
		if ("male") . = "himself"
		if ("female") . = "herself"
		if ("plural") . = "themselves"

/atom/movable/proc/say(words)
	viewers() << "<b>[src]</b> [say_verb], \"[words]\""
	new /atom/movable/chat_message(src, words)

/atom/movable/proc/act(action)
	viewers() << "<i><b>[src]</b> [action]</i>"
	new /atom/movable/chat_message(src, "<i>[action]</i>")
