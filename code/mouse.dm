/mob
	var/list/click_intercept = list()

/atom/Click(location, control, params)
	var/mob/U = usr
	var/P = params2list(params)
	for (var/I in U.click_intercept)
		var/R = call(I, U.click_intercept[I])(src, location, control, P)
		if (R)
			return

	if (!U || !U.can_interact)
		return
	var/A = distance_pixel(U, src) <= U.interact_range
	if (P["middle"])
		return point()
	if (P["left"])
		return left_click(A, P)
	if (P["right"])
		return right_click(A, P)

/atom/proc/left_click(adjacent, params, obj/item)

/atom/proc/right_click(adjacent, params, obj/item)
