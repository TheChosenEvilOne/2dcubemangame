#define RECT(x, y, w, h) list(x, y, w, h)

/datum/map_generator/bsp_rooms
	var/depth = 4
	var/cutoff = 5
	var/wall_thickness = 2

/datum/map_generator/bsp_rooms/configure()
	depth = max(1, min(10, input("tree depth, larger number = more and smaller rooms", "BSP Rooms", 5) as num))
	cutoff = max(0, min(10, input("cutoff, larger number = larger rooms", "BSP Rooms", 5) as num))
	wall_thickness = max(0, min(3, input("wall thickness, larger number = thicker walls", "BSP Rooms", 2) as num))

/datum/map_generator/bsp_rooms/generate(x, y, z)
	var/list/tree = list(list())
	tree[1] += list(RECT(1, 1, world.maxx - 1, world.maxy - 1))
	for (var/i in 2 to depth + 1)
		for (var/i2 in 1 to tree[i - 1].len)
			tree += list(list())
			var/tX = tree[i - 1][i2][1]
			var/tY = tree[i - 1][i2][2]
			var/tW = tree[i - 1][i2][3]
			var/tH = tree[i - 1][i2][4]
			if (tW <= 0 || tH <= 0)
				continue
			if (prob(50))
				// horizontal split
				var/p = round(tW * rand(), 1)
				if ((tW - p) < cutoff || p < cutoff)
					// single
					tree[i] += list(RECT(0, 0, 0, 0))
					tree[i] += list(RECT(tX, tY, tW, tH))
				else
					tree[i] += list(RECT(tX, tY, p, tH))
					tree[i] += list(RECT(tX + p, tY, tW - p, tH))
			else
				// vertical split
				var/p = round(tH * rand(), 1)
				if ((tH - p) < cutoff || p < cutoff)
					// single
					tree[i] += list(RECT(0, 0, 0, 0))
					tree[i] += list(RECT(tX, tY, tW, tH))
				else
					tree[i] += list(RECT(tX, tY, tW, p))
					tree[i] += list(RECT(tX, tY + p, tW, tH - p))
	var/list/dT = tree[depth + 1]
	for (var/i in 1 to dT.len)
		var/tX = dT[i][1]
		var/tY = dT[i][2]
		var/tW = dT[i][3]
		var/tH = dT[i][4]
		if (tW <= 0 || tH <= 0)
			continue
		var/wW = rand(0, wall_thickness)
		var/wH = rand(0, wall_thickness)
		var/T
		for (var/dx in tX to tX + tW)
			for (var/wX in 0 to wW)
				T = locate(dx, tY + wX, z)
				new /turf/wall(T)
				T = locate(dx, tY + tH - wX, z)
				new /turf/wall(T)

		for (var/dy in tY to tY + tH)
			for (var/wY in 0 to wH)
				T = locate(tX + wY, dy, z)
				new /turf/wall(T)
				T = locate(tX + tW - wY, dy, z)
				new /turf/wall(T)