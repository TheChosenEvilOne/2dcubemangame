SYSTEM_CREATE(light)
<<<<<<< HEAD
	name = "lighting v7" // update the number after each rewrite
=======
	name = "lighting v6" // update the number after each rewrite
>>>>>>> 945b3b1 (lighting v6)
	flags = S_PROCESS
	allocated_cpu = 0.5
	update_rate = 0
	priority = 5
<<<<<<< HEAD
	var/list/lights = list()
	var/list/add_queue = list()
	var/list/remove_queue = list()
	var/list/ambient_light = list(15, 6, 0)

/system/light/process()
	while (remove_queue.len)
		check_cpu
		var/atom/source = remove_queue[1]
		remove_queue.Remove(source)
		for (var/atom/movable/abstract/lighting_overlay/LO as anything in lights[source])
			LO.remove_light(source)
		lights.Remove(source)
	while (add_queue.len)
		check_cpu
		var/atom/source = add_queue[1]
		add_queue.Remove(source)
		var/light = source.light
		lights[source] = list()
		for (var/turf/T in view(light - ambient_light[source.z], source))
			lights[source] += T.lighting_overlay
			T.lighting_overlay.add_light(light  - euclidean_distance(T, source), source)
=======
	var/list/add_queue = list()
	var/list/remove_queue = list()
	var/list/ambient_light = list(15, 6, 0)

/system/light/process()
	while (add_queue.len)
		check_cpu
		var/atom/source = add_queue[1]
		add_queue.Remove(source)
		var/light = source.light
		if (istype(source, /turf))
			var/turf/T = source
			T.lighting_overlay.add_light(light, source)
		else
			var/turf/T = get_step(source, 0)
			T.lighting_overlay.add_light(light, source)
		var/list/C = circle(source.x, source.y, light - ambient_light[source.z])
		for (var/i in 1 to C.len step 2)
			var/L = light
			for (var/turf/T2 in find_intersections(source.x, source.y, C[i], C[i+1], source.z))
				L -= T2.light_attenuation
				if (L <= ambient_light[source.z])
					break
				if (T2.opacity)
					T2.lighting_overlay.add_light(L  - euclidean_distance(T2, source), source)
					break
				T2.lighting_overlay.add_light(L  - euclidean_distance(T2, source), source)
	while (remove_queue.len)
		check_cpu
		var/R = remove_queue[1]
		remove_queue.Remove(list(R))
		var/atom/source = R[1]
		var/turf/location = R[2]
		var/light = source.light
		location.lighting_overlay.remove_light(source)
		var/list/C = circle(location.x, location.y, light - ambient_light[location.z])
		for (var/i in 1 to C.len step 2)
			var/L = light
			for (var/turf/T2 in find_intersections(location.x, location.y, C[i], C[i+1], location.z))
				L -= T2.light_attenuation
				if (L <= ambient_light[location.z])
					break
				if (T2.opacity)
					T2.lighting_overlay.remove_light(source)
					break
				T2.lighting_overlay.remove_light(source)
>>>>>>> 945b3b1 (lighting v6)

/system/light/proc/add_light(atom/source)
	if (!source)
		return
	add_queue += source

<<<<<<< HEAD
/system/light/proc/remove_light(atom/source)
	if (!source)
		return
	remove_queue += list(source)
=======
/system/light/proc/remove_light(atom/source, location)
	if (!source)
		return
	remove_queue += list(list(source, location))
>>>>>>> 945b3b1 (lighting v6)
