/atom/movable
	var/throw_speed = 24
	var/throw_range = 14

/datum/throw_object
	var/atom/movable/object
	var/cur_x
	var/cur_y
	var/dir_x
	var/dir_y
	var/range

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
	range *= ICON_SIZE
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

		if (nx > HALF_ICON_SIZE)
			var/step = get_step(src, EAST)
			if (throw_enter(step) || !Move(step))
				nx = HALF_ICON_SIZE
				if (range / 2 > 1)
					range /= 2
					dx = -dx
				else
					break
			nx -= ICON_SIZE
		else if (nx < -HALF_ICON_SIZE)
			var/step = get_step(src, WEST)
			if (throw_enter(step) || !Move(step))
				nx = -HALF_ICON_SIZE
				if (range / 2 > 1)
					range /= 2
					dx = -dx
				else
					break
			nx += ICON_SIZE
		if (ny > HALF_ICON_SIZE)
			var/step = get_step(src, NORTH)
			if (throw_enter(step) || !Move(step))
				ny = HALF_ICON_SIZE
				if (range / 2 > 1)
					range /= 2
					dy = -dy
				else
					break
			ny -= ICON_SIZE
		else if (ny < -HALF_ICON_SIZE)
			var/step = get_step(src, SOUTH)
			if (throw_enter(step) || !Move(step))
				ny = -HALF_ICON_SIZE
				if (range / 2 > 1)
					range /= 2
					dy = -dy
				else
					break
			ny += ICON_SIZE
		sleep (world.tick_lag)
		range -= glide_size

	glide_size = old_gs
	if (keep_pos)
		pixel_x = nx
		pixel_y = ny

/atom/proc/hit_by(atom/movable/A)

/atom/movable/proc/hit_object(atom/A)

/atom/movable/proc/throw_enter(turf/T)
	if (!T)
		return

	if (T.density)
		if (hit_object(T) || T.hit_by(src))
			return 0
		return 1

	for(var/k in T.contents)
		var/atom/movable/A = k
		if(!A.density)
			continue
		if (hit_object(k) || A.hit_by(src))
			return 0
		return 1