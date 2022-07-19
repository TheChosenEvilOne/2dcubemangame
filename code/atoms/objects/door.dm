/obj/door
	name = "door"
	icon_state = "door0"
	opacity = TRUE
	density = TRUE

	var/open = FALSE

/obj/door/left_click(adjacent)
	if (!adjacent)
		return

	if (open)
		close()
	else
		open()
	return 1

/obj/door/proc/open()
	if (open)
		return

	set_opacity(FALSE)
	set_density(FALSE)
	open = TRUE
	flick("a_door1", src)
	icon_state = "door1"

/obj/door/proc/close()
	if (!open)
		return

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

/obj/door/automatic/Cross()
	. = ..()
	if (istype(usr, /mob/dead))
		return
	if (!open)
		open()

/obj/door/automatic/open()
	..()
	spawn (50)
		close()
