/proc/dir2x(dir)
	var/D = dir >> 2
	var/x = D * 2
	. = -(x - 3 * ((D & 1) + (D >> 1)))

/proc/dir2y(dir)
	var/D = dir & 3
	var/y = D * 2
	. = -(y - 3 * ((D & 1) + (D >> 1)))
