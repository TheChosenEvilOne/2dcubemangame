/atom/movable
	var/throw_speed = 24
	var/throw_range = 7

/datum/throw_object
	var/set_pixel_position
	var/cache_move_amount
	var/cur_x = 0
	var/cur_y = 0
	var/dir_x
	var/dir_y
	var/range

/datum/throw_object/New(_dir_x, _dir_y, _range, pixel_position = FALSE)
	dir_x = _dir_x
	dir_y = _dir_y
	cache_move_amount = (abs(_dir_x) + abs(_dir_y))
	range = _range
	set_pixel_position = pixel_position

/datum/throw_object/proc/operator+=(datum/throw_object/other)
	if(istype(other))
		dir_x += other.dir_x
		dir_y += other.dir_y
		cache_move_amount = abs(dir_x) + abs(dir_y)
		// other.range isn't the same as my range, but this will do.
		range += other.range

/atom/movable/proc/throw_at_atom(atom/target, range = throw_range, speed = throw_speed, pixel_position = FALSE)
	throw_at(target.x, target.y, range, speed, pixel_position)

/atom/movable/proc/throw_at(target_x, target_y, range, speed, pixel_position = FALSE)
	if(!target_x || !target_y)
		return 0

	if(!speed)
		speed = throw_speed
	if(!range)
		range = throw_range
	var/angle = arctan(target_x - x, target_y - y)
	var/datum/throw_object/T = new(round(cos(angle) * speed, 1), round(sin(angle) * speed, 1), range * ICON_SIZE, pixel_position)
	sys_throwing.process_throw(src, T)

/atom/proc/hit_by(atom/movable/A)

/atom/movable/proc/hit_object(atom/A)

/atom/movable/proc/throw_enter(turf/T)
	if (!T)
		return

	if (T.density)
		if (hit_object(T) || T.hit_by(src))
			return FALSE
		return TRUE

	for(var/k in T.contents)
		var/atom/movable/A = k
		if(!A.density)
			continue
		if (hit_object(k) || A.hit_by(src))
			return FALSE
		return TRUE