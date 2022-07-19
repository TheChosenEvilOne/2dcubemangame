/proc/dir2x(dir)
	var/D = dir >> 2
	var/x = D * 2
	. = -(x - 3 * ((D & 1) + (D >> 1)))

/proc/dir2y(dir)
	var/D = dir & 3
	var/y = D * 2
	. = -(y - 3 * ((D & 1) + (D >> 1)))

/proc/euclidean_distance(atom/loc1, atom/loc2)
	return sqrt((loc1.x - loc2.x) ** 2 + (loc1.y - loc2.y) ** 2)

/proc/distance_pixel(atom/loc1, atom/loc2)
	var/x1 = loc1.x * 32 + loc1.pixel_x
	var/x2 = loc2.x * 32 + loc2.pixel_x
	var/y1 = loc1.y * 32 + loc1.pixel_y
	var/y2 = loc2.y * 32 + loc2.pixel_y
	return sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)

/proc/circle(cx, cy, r)
	. = list()

	var/x = r
	var/y = 0
	var/o = round(1 - x)
	while (y <= x)
		. += list(list(cx + x, cy + y))
		. += list(list(cx + x, cy - y))
		. += list(list(cx - x, cy + y))
		. += list(list(cx - x, cy - y))
		. += list(list(cx + y, cy + x))
		. += list(list(cx + y, cy - x))
		. += list(list(cx - y, cy + x))
		. += list(list(cx - y, cy - x))

		y += 1
		if (o <= 0)
			o += (2 * y) + 1
		else
			x -= 1
			o += (2 * (y - x)) + 1

#define OCTANT(f1, f2, f3, f4, f5, i1, s1, r1, r2) \
	f1; f2; f3; \
	for (nr = 0, f4, f5) { \
			if (nr < liconst) { \
			if (i1) { . += r1; } else { . += locate(cX, cY, z) } \
		} else { \
			s1; \
			if (nr -= liconst) { . += r2; . += r1; } \
			else { . += locate(cX, cY, z) }\
		} \
	}
#define F_UP	locate(cX, cY + 1, z)
#define F_DOWN	locate(cX, cY - 1, z)
#define F_LEFT	locate(cX - 1, cY, z)
#define F_RIGHT	locate(cX + 1, cY, z)
/proc/find_intersections(x1, y1, x2, y2, z)
	. = list()
	var/cX = 0
	var/cY = 0
	var/dX = x2 - x1
	var/dY = y2 - y1
	var/nr = 0
	var/liconst
	if ((dX >= 0) && (dY >= 0) && (dY < dX)) {
		OCTANT(cX = x1 + 1,	cY = y1,	liconst = dX - dY,	cX < x2, cX++, nr += dY, cY++, F_UP, F_LEFT)
	} else if ((dX > 0) && (dY >= 0) && (dY >= dX)) {
		OCTANT(cY = y1 + 1,	cX = x1,	liconst = dY - dX,	cY < y2, cY++, nr += dX, cX++, F_RIGHT, F_DOWN)
	} else if ((dX <= 0) && (dY >= 0) && (dY > -dX)) {
		OCTANT(cY = y1 + 1,	cX = x1,	liconst = dY + dX,	cY < y2, cY++, nr -= dX, cX--, F_LEFT, F_DOWN)
	} else if ((dX <= 0) && (dY > 0) && (dY <= -dX)) {
		OCTANT(cX = x1 - 1,	cY = y1,	liconst = -dX - dY,	cX > x2, cX--, nr += dY, cY++, F_UP, F_RIGHT)
	} else if ((dX <= 0) && (dY <= 0) && (dY > dX)) {
		OCTANT(cX = x1 - 1,	cY = y1,	liconst = -dX + dY,	cX > x2, cX--, nr -= dY, cY--, F_DOWN, F_RIGHT)
	} else if ((dX < 0) && (dY <= 0) && (dY <= dX)) {
		OCTANT(cY = y1 - 1,	cX = x1,	liconst = -dY + dX,	cY > y2, cY--, nr -= dX, cX--, F_LEFT, F_UP)
	} else if ((dX >= 0) && (dY <= 0) && (-dY > dX)) {
		OCTANT(cY = y1 - 1,	cX = x1,	liconst = -dY - dX,	cY > y2, cY--, nr += dX, cX++, F_RIGHT, F_UP)
	} else if ((dX >= 0) && (dY < 0) && (-dY <= dX)) {
		OCTANT(cX = x1 + 1,	cY = y1,	liconst = dX + dY,	cX < x2, cX++, nr -= dY, cY--, F_DOWN, F_LEFT)
	} else . += locate(x2, y2, z)
#undef OCTANT
#undef F_UP
#undef F_DOWN
#undef F_LEFT
#undef F_RIGHT
