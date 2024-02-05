/obj/door
	name = "door"
	icon_state = "door0"
	opacity = TRUE
	density = TRUE
	interactable = TRUE

	var/open = FALSE

/obj/door/interact(who)
	if (open)
		close()
	else
		open()
	return TRUE

/obj/door/proc/open()
	if (open)
		return

	playsound(src, 'sound/door.ogg', vol=100, wall_attenuation=TRUE)
	set_opacity(FALSE)
	set_density(FALSE)
	open = TRUE
	flick("a_door1", src)
	icon_state = "door1"

/obj/door/proc/close()
	if (!open)
		return

	playsound(src, 'sound/door.ogg', vol=100, wall_attenuation=TRUE)
	set_opacity(TRUE)
	set_density(TRUE)
	open = FALSE
	flick("a_door0", src)
	icon_state = "door0"

/obj/door/projectile_impact(atom/movable/projectile/P)
	if (!istype(P, /atom/movable/projectile/cannon_ball))
		return ..()
	take_damage(integrity)
	return TRUE

/obj/door/automatic
	name = "automatic door"
	icon_state = "door0"
	managed_overlays = list("detector" = "overlay_autodoor")

/obj/door/automatic/bump(thing)
	. = ..()
	if (istype(thing, /mob/dead))
		return
	if (!open)
		open()

/obj/door/automatic/open()
	..()
	spawn (50)
		close()
