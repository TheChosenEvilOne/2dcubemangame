SYSTEM_CREATE(light)
	name = "lighting v5" // update the number after each rewrite
	flags = S_PROCESS
	update_rate = 0
	var/list/prop_list = list()
	var/ambient_light = 8

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

		var/op = 0
		for (var/atom/A as anything in T)
			if (A.opacity)
				op = 1
				break
		if (op)
			continue

		var/spread = list()
		var/turf/T2 = locate(T.x + 1, T.y, T.z)
		if (T2)
			var/T2L = T2.lighting_overlay.light_level
			if (T2L < (L - 1))
				spread += T2
		T2 = locate(T.x - 1, T.y, T.z)
		if (T2)
			var/T2L = T2.lighting_overlay.light_level
			if (T2L < (L - 1))
				spread += T2
		T2 = locate(T.x, T.y + 1, T.z)
		if (T2)
			var/T2L = T2.lighting_overlay.light_level
			if (T2L < (L - 1))
				spread += T2
		T2 = locate(T.x, T.y - 1, T.z)
		if (T2)
			var/T2L = T2.lighting_overlay.light_level
			if (T2L < (L - 1))
				spread += T2

		for (var/turf/S in spread)
			propagate_light(S, L - 1)


/system/light/proc/propagate_light(turf/T, light)
	if (!istype(T))
		T = get_step(T, 0)
	prop_list += list(list(T, light))