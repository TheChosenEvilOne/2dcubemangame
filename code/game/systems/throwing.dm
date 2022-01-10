SYSTEM_CREATE(throwing)
	name = "throwing"
	flags = S_PROCESS
	update_rate = 0
	allocated_cpu = 0.1
	priority = 15
	var/list/datum/throw_object/throws = list()

/system/throwing/process()
	for (var/atom/movable/O in throws)
		var/datum/throw_object/T = throws[O]
		var/range = T.range
		if (!O.loc || range <= 0)
			stop_throw(O)
			continue
		var/should_animate = TRUE
		T.cur_x += T.dir_x
		T.cur_y += T.dir_y

		if (T.cur_x > HALF_ICON_SIZE)
			should_animate = FALSE
			var/step = get_step(O, EAST)
			if (O.throw_enter(step) || !O.Move(step))
				T.cur_x = HALF_ICON_SIZE
				if (range / 2 > 1)
					range /= 2
					T.dir_x = -T.dir_x
				else
					stop_throw(O)
					continue
			if (T.set_pixel_position)
				animate(O, pixel_x = T.cur_x, pixel_y = T.cur_y, flags = ANIMATION_PARALLEL)
			T.cur_x -= ICON_SIZE
		else if (T.cur_x < -HALF_ICON_SIZE)
			should_animate = FALSE
			var/step = get_step(O, WEST)
			if (O.throw_enter(step) || !O.Move(step))
				T.cur_x = -HALF_ICON_SIZE
				if (range / 2 > 1)
					range /= 2
					T.dir_x = -T.dir_x
				else
					stop_throw(O)
					continue
			if (T.set_pixel_position)
				animate(O, pixel_x = T.cur_x, pixel_y = T.cur_y, flags = ANIMATION_PARALLEL)
			T.cur_x += ICON_SIZE
		if (T.cur_y > HALF_ICON_SIZE)
			should_animate = FALSE
			var/step = get_step(O, NORTH)
			if (O.throw_enter(step) || !O.Move(step))
				T.cur_y = HALF_ICON_SIZE
				if (range / 2 > 1)
					range /= 2
					T.dir_y = -T.dir_y
				else
					stop_throw(O)
					continue
			if (T.set_pixel_position)
				animate(O, pixel_x = T.cur_x, pixel_y = T.cur_y, flags = ANIMATION_PARALLEL)
			T.cur_y -= ICON_SIZE
		else if (T.cur_y < -HALF_ICON_SIZE)
			should_animate = FALSE
			var/step = get_step(O, SOUTH)
			if (O.throw_enter(step) || !O.Move(step))
				T.cur_y = -HALF_ICON_SIZE
				if (range / 2 > 1)
					range /= 2
					T.dir_y = -T.dir_y
				else
					stop_throw(O)
					continue
			if (T.set_pixel_position)
				animate(O, pixel_x = T.cur_x, pixel_y = T.cur_y, flags = ANIMATION_PARALLEL)
			T.cur_y += ICON_SIZE
		T.range = range - T.cache_move_amount
		if (T.set_pixel_position)
			if (should_animate)
				animate(O, pixel_x = T.cur_x, pixel_y = T.cur_y, flags = ANIMATION_PARALLEL)
			O.pixel_x = T.cur_x
			O.pixel_y = T.cur_y

/system/throwing/proc/stop_throw(atom/movable/O)
	var/datum/throw_object/T = throws[O]
	throws.Remove(O)
	if (!T.set_pixel_position)
		return
	O.animate_movement = initial(O.animate_movement)

/system/throwing/proc/process_throw(atom/movable/O, datum/throw_object/T)
	if (flags & S_PAUSED || master.paused)
		return
	if (throws[O])
		throws[O] += T
		return
	throws[O] = T
	if (!T.set_pixel_position)
		return
	O.animate_movement = NO_STEPS