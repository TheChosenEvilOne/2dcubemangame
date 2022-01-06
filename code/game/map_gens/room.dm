/datum/map_generator/room/generate(x, y, z)
	var/w = rand(5, 10)
	var/h = rand(5, 10)

	x -= w / 2
	y -= h / 2

	if (x <= 0)
		x += 1 + -x
	if (y <= 0)
		y += 1 + -y
	if (x + w >= world.maxx)
		w -= 1 + (world.maxx - w + x)
	if (y + h >= world.maxy)
		h -= 1 + (world.maxx - h + y)

	var/T
	for (var/dx in x to x + w)
		T = locate(dx, y, z)
		new /turf/wall(T)
		T = locate(dx, y + h, z)
		new /turf/wall(T)

	for (var/dy in y to y + h)
		T = locate(x, dy, z)
		new /turf/wall(T)
		T = locate(x + w, dy, z)
		new /turf/wall(T)