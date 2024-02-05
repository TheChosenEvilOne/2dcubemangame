/turf/floor/open
	var/atom/movable/below_viewer

/turf/floor/open/New()
	. = ..()
	var/T = locate(x, y, z + 1)
	if (!T)
		return TRUE
	below_viewer = new /atom/movable/abstract/below_viewer(T, src)

/turf/floor/open/Del()
	if (below_viewer)
		below_viewer.loc = null
		below_viewer.vis_contents.Cut()
		vis_contents.Cut()
	. = ..()

/turf/floor/open/glass
	name = "glass floor"
	icon_state = "glass"

/turf/floor/open/hole
	name = "hole"
	icon_state = "hole"

/turf/floor/open/hole/New()
	. = ..()
	if (.)
		new world.turf(src)

/turf/floor/open/hole/enter(atom/movable/A)
	var/turf/T = locate(x, y, z + 1)
	if (A.Move(T))
		viewers(src) << "[A] falls down \the [src]!"
		A << "You fall down \the [src]!"
		return FALSE
	return TRUE