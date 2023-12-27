
/proc/get_sfx(sound)
	if (isfile(sound))
		return sound
	switch (sound)
		if ("walkwood")
			return pick('sound/wood_walk1.ogg','sound/wood_walk2.ogg','sound/wood_walk3.ogg','sound/wood_walk4.ogg')

/proc/playsound(atom/source, sound, vol = 50, range = 7, falloff = TRUE, wall_attenuation = FALSE)
	var/sfx = get_sfx(sound)
	if (!sfx) return
	var/sound/S = sound(get_sfx(sound), volume = vol)
	for (var/ckey in clients)
		var/mob/M = clients[ckey].mob
		if (M.z != source.z || euclidean_distance(M, source) > range)
			continue
		if (wall_attenuation)
			for (var/turf/T as anything in find_intersections(source.x, source.y, M.x, M.y, source.z))
				if (T.opacity)
					vol /= 2
		S.x = source.x - M.x
		S.y = source.y - M.y
		S.falloff = falloff
		M << S