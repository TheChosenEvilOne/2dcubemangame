/obj/door
	name = "door"
	icon_state = "door0"
	opacity = 1
	density = 1

	var/open = 0

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

	density = opacity = 0
	open = 1
	flick("a_door1", src)
	icon_state = "door1"

/obj/door/proc/close()
	if (!open)
		return

	density = opacity = 1
	open = 0
	flick("a_door0", src)
	icon_state = "door0"

/obj/door/projectile_impact(atom/movable/projectile/P)
	if (!istype(P, /atom/movable/projectile/cannon_ball))
		return ..()
	take_damage(integrity)
	return 1

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
