PROCESSING_CREATE(conveyor)
	name = "conveyor process"
	update_rate = 2
	priority = 500
	allocated_cpu = 0.05

/system/processing/conveyor/process()
	if (!processing.len)
		return
	var/move_queue = list(list(), list(), list(), list(), list(), list(), list(), list())
	for (var/atom/movable/C as anything in processing)
		move_queue[C.dir] += (C.loc.contents - C)
	for (var/I in 1 to 8)
		check_cpu
		for (var/atom/movable/M as anything in move_queue[I])
			M.glide_size = DELAY2GLIDESIZE(update_rate)
			M.Move(get_step(M, I))