/datum/map_generator/cellural_automata
	var/B = list()
	var/S = list()
	var/WFS = FALSE
	var/wall_ratio = 50
	var/process = list()

/datum/map_generator/cellural_automata/configure(_B, _S, _wfs, _wall_ratio, _process)
	if (_B)
		B = _B
	else
		var/i
		while (!isnull((i = input("Birth rule, press cancel to continue.", "B") as num|null)))
			B += i

	if (_S)
		S = _S
	else
		var/i
		while (!isnull((i = input("Stay rule, press cancel to continue.", "S") as num|null)))
			S += i

	if (_wall_ratio)
		wall_ratio = _wall_ratio
	else
		_wall_ratio = max(0, min(input("0 to 100", "Wall Percentage", 50) as num, 100))

	if (_wfs)
		WFS = _wfs
	else
		WFS = alert("Invert walls and floors?", "WFS", "No", "Yes") == "Yes" ? TRUE : FALSE

	if (_process)
		process = _process
	else
		var/t
		while ((t = input("Round Type") as null|anything in list("Random", "Sequential", "Full")))
			switch (t)
				if ("Random")
					var/I = input("How many random iterations?", "Iterations", 1000) as num
					process += list(list(t, I))
				if ("Sequential")
					process += list(list(t))
				if ("Full")
					process += list(list(t))

/datum/map_generator/cellural_automata/proc/neighbour_count(map, x, y)
	var/nC = 0
	for (var/dX in -1 to 1)
		for (var/dY in -1 to 1)
			if (dX == 0 && dY == 0)
				continue
			if (dX + x <= 0 || dX + x >= world.maxx || dY + y <= 0 || dY + y >= world.maxy)
				continue
			nC += map[x + dX][y + dY]
	return nC

/datum/map_generator/cellural_automata/generate(_, _, z)
	var map[world.maxx][world.maxy]
	var buf[world.maxx][world.maxy]
	for (var/x in 1 to world.maxx)
		for (var/y in 1 to world.maxy)
			map[x][y] = prob(wall_ratio)

	for (var/p in process)
		switch(p[1])
			if ("Random")
				var/x = rand(1, world.maxx)
				var/y = rand(1, world.maxy)
				var/nC = neighbour_count(map, x, y)
				if (nC in B)
					map[x][y] = 1 // Birth
				else if (nC in S)
					// Survival
				else
					map[x][y] = 0 // Death
			if ("Sequential")
				for (var/x in 1 to world.maxx)
					for (var/y in 1 to world.maxy)
						var/nC = neighbour_count(map, x, y)
						if (nC in B)
							map[x][y] = 1 // Birth
						else if (nC in S)
							// Survival
						else
							map[x][y] = 0 // Death
			if ("Full")
				buf = map.Copy()
				for (var/x in 1 to world.maxx)
					for (var/y in 1 to world.maxy)
						var/nC = neighbour_count(buf, x, y)
						if (nC in B)
							map[x][y] = 1 // Birth
						else if (nC in S)
							// Survival
						else
							map[x][y] = 0 // Death

	for (var/x in 1 to world.maxx)
		for (var/y in 1 to world.maxy)
			if (map[x][y] ^ WFS)
				new /turf/wall(locate(x, y, z))
			else
				new /turf/floor/gray(locate(x, y, z))