
/proc/get_sfx(sound)
	if (isfile(sound))
		return sound

/proc/playsound(var/atom/source, var/sound, var/vol = 50, var/range = 7, var/falloff = TRUE, var/wall_attenuation = FALSE)
	for (var/ckey in clients)
		var/mob/M = clients[ckey].mob
		if (M.z != source.z || euclidean_distance(M, source) > range)
			continue
		if (wall_attenuation)
			for (var/turf/T as anything in find_intersections(source.x, source.y, M.x, M.y, source.z))
				if (T.opacity)
					vol /= 2
		var/sound/S = sound(sound, volume = vol)
		S.x = source.x - M.x
		S.y = source.y - M.y
		S.falloff = falloff
		M << S