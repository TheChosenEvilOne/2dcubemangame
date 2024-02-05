SYSTEM_CREATE(light)
	name = "lighting v7" // update the number after each rewrite
	flags = S_PROCESS
	allocated_cpu = 0.5
	update_rate = 0
	priority = 5
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
		var/amli = ambient_light[min(source.z, length(ambient_light))]
		for (var/turf/T in view(light - amli, source))
			lights[source] += T.lighting_overlay
			T.lighting_overlay.add_light(light  - euclidean_distance(T, source), source)

/system/light/proc/add_light(atom/source)
	if (!source)
		return
	add_queue += source

/system/light/proc/remove_light(atom/source)
	if (!source)
		return
	remove_queue += list(source)
