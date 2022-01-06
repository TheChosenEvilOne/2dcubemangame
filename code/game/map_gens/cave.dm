/datum/map_generator/cave/generate(x, y, z)
	var/map = new/list(world.maxx, world.maxy)
	var/list/tracers = list()
	for (var/i in 0 to rand(8))
		tracers += list(list(x, y, rand() * 2 - 1, rand() * 2 - 1, 75))

	while (tracers.len > 0)
		for (var/L in tracers)
			if (L[1] <= 3 || L[1] >= (world.maxx - 3))
				L[3] = -L[3]
				L[1] += L[3] * 10
			if (L[2] <= 3 || L[2] >= (world.maxx - 3))
				L[4] = -L[4]
				L[2] += L[4] * 10
			for (var/dx in -1 to 1)
				for (var/dy in -1 to 1)
					map[L[1]+dx][L[2]+dy] = 1
			L[1] += L[3]
			L[2] += L[4]
			var/theta = rand(-5, 5)
			L[3] = L[3] * cos(theta) - L[4] * sin(theta)
			L[4] = L[3] * sin(theta) + L[4] * cos(theta)
			L[5]--
			if (L[5] < 0)
				tracers -= list(L)
			if (prob(1))
				theta = prob(50) ? rand(-105, -75) : rand(105, 75)
				var/dX = L[3] * cos(theta) - L[4] * sin(theta)
				var/dY = L[3] * sin(theta) + L[4] * cos(theta)
				tracers += list(list(L[1], L[2], dX, dY, 25))


	for (var/dx in 1 to world.maxx)
		for (var/dy in 1 to world.maxy)
			var/T = locate(dx, dy, z)
			if (map[dx][dy] <= 0)
				new /turf/wall/rock/gray(T)
			else
				new /turf/floor/dort(T)