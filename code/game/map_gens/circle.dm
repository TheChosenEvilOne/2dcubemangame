/datum/map_generator/circle
	var/r
	var/h

/datum/map_generator/circle/configure(_r)
	if (!_r)
		r = max(1, min(10, input("circle radius", "Circle", 5) as num))

/datum/map_generator/circle/generate(x, y, z)
	for (var/C in circle(x, y, r))
		new /turf/wall(locate(C[1], C[2], z))