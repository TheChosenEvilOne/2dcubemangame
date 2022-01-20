/atom/movable/abstract/below_viewer
	vis_flags = NONE
	layer = BELOW_TURF_LAYER
	plane = BELOW_PLANE

/atom/movable/abstract/below_viewer/New()
	var/turf/T = locate(x, y, z - 1)
	T.vis_contents += src
	vis_contents += loc
	loc = null