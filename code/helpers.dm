/proc/dir2x(dir)
	var/D = dir >> 2
	var/x = D * 2
	. = -(x - 3 * ((D & 1) + (D >> 1)))

/proc/dir2y(dir)
	var/D = dir & 3
	var/y = D * 2
	. = -(y - 3 * ((D & 1) + (D >> 1)))

/proc/distance_pixel(atom/loc1, atom/loc2)
	var/x1 = loc1.x * 32 + loc1.pixel_x
	var/x2 = loc2.x * 32 + loc2.pixel_x
	var/y1 = loc1.y * 32 + loc1.pixel_y
	var/y2 = loc2.y * 32 + loc2.pixel_y
	return sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)