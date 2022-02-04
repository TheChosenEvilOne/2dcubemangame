/turf/open
	icon = 'icons/turfs/floors.dmi'
	var/atom/movable/below_viewer

/turf/open/New()
	. = ..()
	var/T = locate(x, y, z + 1)
	if (!T)
		return
	below_viewer = new /atom/movable/abstract/below_viewer(T, src)

/turf/open/Del()
	if (below_viewer)
		below_viewer.loc = null
		below_viewer.vis_contents.Cut()
		vis_contents.Cut()
	. = ..()

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
	if (A.Move(T))
		viewers() << "[A] falls down \the [src]!"