/turf/open
	icon = 'icons/turfs/floors.dmi'

/turf/open/New()
	. = ..()
	var/T = locate(x, y, z + 1)
	if (!T)
		return
	new /atom/movable/abstract/below_viewer(T)

/turf/open/Del()
	vis_contents.Cut()

/turf/open/glass
	name = "glass floor"
	icon_state = "glass"

/turf/open/hole
	name = "hole"
	icon_state = "hole"

/turf/open/hole/Entered(atom/movable/A)
	var/turf/T = locate(x, y, z + 1)
	if (!T)
		return ..()
	A.loc = T
	viewers() << "[A] falls down \the [src]!"