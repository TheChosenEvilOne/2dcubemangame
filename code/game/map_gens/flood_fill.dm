/datum/map_generator/flood_fill
	var/filling_path
	var/fill_path = /turf/floor/gray

/datum/map_generator/flood_fill/configure(path)
	if (path && ispath(path, /turf))
		fill_path = path
		return
	path = input("turf path") as null|text
	if (!path)
		return
	path = text2path(path)
	if (!path || !ispath(path, /turf))
		return
	fill_path = path

/datum/map_generator/flood_fill/generate(x, y, z)
	var/turf/T = locate(x, y, z)
	if (!T)
		return
	filling_path = T.type
	if (filling_path == fill_path)
		return
	fill(T)

/datum/map_generator/flood_fill/proc/fill(turf/T)
	var/list/filling = list(T)
	new fill_path(T)
	while (filling.len)
		var/turf/F = filling[1]
		filling -= F
		var/turf/T2 = locate(F.x + 1, F.y, F.z)
		if (T2 && T2.type == filling_path)
			new fill_path(T2)
			filling += T2
		T2 = locate(F.x - 1, F.y, F.z)
		if (T2 && T2.type == filling_path)
			new fill_path(T2)
			filling += T2
		T2 = locate(F.x, F.y + 1, F.z)
		if (T2 && T2.type == filling_path)
			new fill_path(T2)
			filling += T2
		T2 = locate(F.x, F.y - 1, F.z)
		if (T2 && T2.type == filling_path)
			new fill_path(T2)
			filling += T2