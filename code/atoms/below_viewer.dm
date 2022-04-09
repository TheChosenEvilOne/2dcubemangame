/atom/movable/abstract/below_viewer
	vis_flags = NONE
	layer = BELOW_TURF_LAYER
	plane = BELOW_PLANE

/atom/movable/abstract/below_viewer/New(turf/loc, turf/above)
	above.vis_contents += src
	vis_contents += loc