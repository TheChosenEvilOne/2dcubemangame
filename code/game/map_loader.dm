/proc/load_map(map_text, centre = FALSE, x = 1, y = 1, z = world.maxz)
	var/list/map
	if (copytext(map_text, 1, findtext(map_text, "\n")) == "//MAP CONVERTED BY dmm2tgm.py THIS HEADER COMMENT PREVENTS RECONVERSION, DO NOT REMOVE")
		usr << "WARN: map loader compatibility with TGM maps is not guaranteed."
		map = __load_tgm(map_text)
	else
		map = __load_dmm(map_text)
	var/mx = map["size"][1]
	var/my = map["size"][2]
	var/mz = map["size"][3]
	var/list/keys = map["keys"]
	map = map["map"]
	var/rM = list(
		list( 1, 0, 0),
		list( 0,-1, 0),
		list( 0, 0, 1)
	)
	if (z + mz - 1 > world.maxz) world.maxz = z + mz - 1
	if (centre)
		x = x - mx / 2 * rM[1][1] - my / 2 * rM[1][2] - mz / 2 * rM[1][3]
		y = y - mx / 2 * rM[2][1] - my / 2 * rM[2][2] - mz / 2 * rM[2][3]
		z = z
		for (var/dz in 0 to mz - 1)
			for (var/dy in 0 to my - 1)
				for (var/dx in 1 to mx)
					var/k = map[dx + mx * dy + mx * my * dz]
					var/px = x + (dx * rM[1][1] + dy * rM[1][2] + dz * rM[1][3])
					var/py = y + (dy * rM[2][2] + dx * rM[2][1] + dz * rM[2][3]) + 1
					var/pz = z + (dz * rM[3][3] + dx * rM[3][1] + dy * rM[3][2])
					var/pos = locate(px, py, pz)
					for (var/p in keys[k])
						if (istype(p, /list))
							var/path = p[1]
							var/_vars = p[2]
							var/atom/t = new path(pos)
							for (var/v in _vars) t.vars[v] = _vars[v]
						else
							new p(pos)
	else
		x = min(mx * rM[1][1] - my * rM[1][2] - mz * rM[1][3], 0)
		y = min(my * rM[2][2] - mz * rM[2][3] - mx * rM[2][1], 0)
		z = min(mz * rM[3][3] - mx * rM[3][1] - my * rM[3][2], 0)
		for (var/dz in 0 to mz - 1)
			for (var/dy in 0 to my - 1)
				for (var/dx in 1 to mx)
					var/k = map[dx + mx * dy + mx * my * dz]
					var/px = (dx * rM[1][1] + dy * rM[1][2] + dz * rM[1][3]) - x
					var/py = (dx * rM[2][1] + dy * rM[2][2] + dz * rM[2][3]) - y
					var/pz = (dx * rM[3][1] + dy * rM[3][2] + dz * rM[3][3]) - z
					var/pos = locate(px, py, pz)
					for (var/p in keys[k])
						if (istype(p, /list))
							var/path = p[1]
							var/_vars = p[2]
							var/atom/t = new path(pos)
							for (var/v in _vars) t.vars[v] = _vars[v]
						else
							new p(pos)

/proc/__arg_type_conversion(arg_value)
	if (arg_value[1] == "\"") return copytext(arg_value, 2, -1)
	else if (arg_value[1] == "'") return file(copytext(arg_value, 2, -1))
	else if (arg_value[1] == "/") return text2path(arg_value)
	else if (arg_value == "null") return null
	else if (findtext(arg_value, "list("))
		world << "list type not yet implemented."
		return list()
	else return text2num(arg_value)

/proc/__parse_args(arg_text)
	var/out = list()
	var/anb = ""
	var/avb = ""
	var/a_s = 0
	var/al = length(arg_text)
	var/i = 1
	while (i <= al)
		var/c = arg_text[i++]
		if (!a_s)
			var/ei = findtext(arg_text, "=", i)
			anb = trimtext(copytext(arg_text, i - 1, ei - 1))
			i = ei + 2
			a_s = 1
			avb = ""
		else
			if (c == "\"")
				var/esc = 1
				while (c != "\"" || esc)
					if (esc) esc = 0
					else if (c == "\\") esc = 1
					avb += c
					c = arg_text[i++]
			else if (c == ";")
				a_s = 0
				out[trimtext(anb)] = trimtext(avb)
				anb = ""
				continue
			avb += c
	out[anb] = avb
	for (var/a in out) out[a] = __arg_type_conversion(out[a])
	return out

/proc/__argful_key(key)
	var/k = list()
	var/i = 1
	var/kl = length(key)
	var/kb = ""
	while (i <= kl)
		var/c = key[i++]
		switch (c)
			if ("{")
				var/s = i
				var/d = 1
				while (d)
					c = key[i++]
					switch (c)
						if ("{") d++
						if ("}") d--
				k += list(list(text2path(kb), __parse_args(copytext(key, s, i - 1))))
				kb = ""
				i++
				continue
			if (",")
				k += text2path(kb)
				kb = ""
				continue
		kb += c
	return k

/proc/__load_dmm(map_text)
	var/list/map_split = splittext(map_text, "\n\n")
	var/list/key_list = splittext(map_split[1], "\n")
	var/list/keys = list()
	var/key_length,k
	for (var/i in 1 to length(key_list))
		k = key_list[i]
		var/e = findtext(k, "=")
		var/ea = copytext(k, e + 3, -1)
		k = copytext(k, 2, e - 2)
		var/key
		if (findtext(ea, "{"))
			key = __argful_key(ea)
		else
			key = list()
			var/list/atoms = splittext(ea, ",")
			for (var/a in atoms) key += text2path(a)
		keys[k] = key
	key_length = length(k)
	var/BOZGOR_part = map_split[2]
	var/s = 0
	var/mx,my,mz
	var/map = list()
	while ((s = findtext(BOZGOR_part, "(", s + 1)))
		var/pos = splittext(copytext(BOZGOR_part, s + 1, findtext(BOZGOR_part, ")", s)), ",")
		mx = text2num(pos[1]);my = text2num(pos[2]);mz = text2num(pos[3])
		var/BOZGORS = splittext(trimtext(copytext(BOZGOR_part, findtext(BOZGOR_part, "{", s) + 2, findtext(BOZGOR_part, "}", s) - 1)), "\n")
		for (var/BOZGOR in BOZGORS)
			for (var/j in 1 to length(BOZGOR) step key_length)
				map += copytext(BOZGOR, j, j + key_length)
		mx = length(BOZGORS[1]) / key_length
		my = length(BOZGORS)

	return list(size = list(mx, my, mz), keys = keys, map = map)

/proc/__load_tgm(map_text)
	usr << "NYI"