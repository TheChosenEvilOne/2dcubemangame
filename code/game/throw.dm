/atom/movable
	var/throw_speed = 24
	var/throw_range = 14

/atom/movable/proc/throw_at_atom(atom/target, range, speed, keep_pos = 0)
	throw_at(target.x, target.y, range, speed, keep_pos)

/atom/movable/proc/throw_at(target_x, target_y, range, speed, keep_pos = 0)
	set waitfor = FALSE
	if(!target_x || !target_y || !src)
		return 0

	if(!speed)
		speed = throw_speed
	if(!range)
		range = throw_range
	range *= 32
	var/animation_time = (range / speed * world.tick_lag) / 3
	animate(src, transform = turn(matrix(), 120), time = animation_time, loop = 1)
	animate(transform = turn(matrix(), 240), time = animation_time)
	animate(transform = null, time = animation_time)

	var/angle = arctan(target_x - x, target_y - y)
	var/dx = round(cos(angle) * speed, 1)
	var/dy = round(sin(angle) * speed, 1)
	var/nx = 0
	var/ny = 0
	var/old_gs = glide_size
	glide_size = abs(dx) + abs(dy)
	while (range >= 0)
		nx += dx
		ny += dy

		if (nx > 16)
			nx -= 32
			if (!step(src, EAST))
				break
		else if (nx < -16)
			nx += 32
			if (!step(src, WEST))
				break

		if (ny > 16)
			ny -= 32
			if (!step(src, NORTH))
				break
		else if (ny < -16)
			ny += 32
			if (!step(src, SOUTH))
				break
		sleep (world.tick_lag)
		range -= glide_size

	glide_size = old_gs
	if (keep_pos)
		pixel_x = nx
		pixel_y = ny