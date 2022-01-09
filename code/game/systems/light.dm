SYSTEM_CREATE(light)
	name = "lighting v5" // update the number after each rewrite
	flags = S_PROCESS
	allocated_cpu = 0.5
	update_rate = 0
	var/list/prop_list = list()
	var/ambient_light = 4

/system/light/process()
	while (prop_list.len)
		check_cpu

		var/light = prop_list[1]
		prop_list -= list(light)
		var/turf/T = light[1]
		var/L = light[2]
		var/LC = T.lighting_overlay.light_level
		if (L == LC)
			continue
		T.lighting_overlay.set_light_level(L)

		var/op = FALSE
		for (var/atom/A as anything in T)
			if (A.opacity)
				op = TRUE
				break
		if (op)
			continue

		var/spread = list()
		var/darken = list()
		var/turf/T2 = locate(T.x + 1, T.y, T.z)
		if (T2)
			var/T2L = T2.lighting_overlay.light_level
			if (T2L < (L - 1))
				spread += T2
			else if (L < T2L && T2.lighting_overlay.source == get_dir(T2, T))
				darken += T2
		T2 = locate(T.x - 1, T.y, T.z)
		if (T2)
			var/T2L = T2.lighting_overlay.light_level
			if (T2L < (L - 1))
				spread += T2
			else if (L < T2L && T2.lighting_overlay.source == get_dir(T2, T))
				darken += T2
		T2 = locate(T.x, T.y + 1, T.z)
		if (T2)
			var/T2L = T2.lighting_overlay.light_level
			if (T2L < (L - 1))
				spread += T2
			else if (L < T2L && T2.lighting_overlay.source == get_dir(T2, T))
				darken += T2
		T2 = locate(T.x, T.y - 1, T.z)
		if (T2)
			var/T2L = T2.lighting_overlay.light_level
			if (T2L < (L - 1))
				spread += T2
			else if (L < T2L && T2.lighting_overlay.source == get_dir(T2, T))
				darken += T2

		for (var/turf/S in spread)
			S.lighting_overlay.source = get_dir(S, T)
			propagate_light(S, L - 1)

		for (var/turf/S in darken)
			S.lighting_overlay.source = 0
			propagate_light(S, L)



/system/light/proc/propagate_light(turf/T, light)
	if (!istype(T))
		T = get_step(T, 0)
	prop_list += list(list(T, light))