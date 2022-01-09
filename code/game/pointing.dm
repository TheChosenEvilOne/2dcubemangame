/atom/movable/arrow
	icon = 'icons/objs.dmi'
	icon_state = "arrow"
	appearance_flags = RESET_COLOR | RESET_ALPHA
	layer = UNDER_LIGHTING_LAYER
	mouse_opacity = 0

/atom/proc/point()
	var/atom/movable/L = src
	hearers() << "[usr] points at [L]."
	var/atom/movable/arrow/A = new()
	L.vis_contents += A
	animate(A, pixel_y = 16, time = 2, loop = 10)
	animate(pixel_y = 0, time = 2)
	spawn (22)
		L.vis_contents -= A
		A.destroy()
	return TRUE