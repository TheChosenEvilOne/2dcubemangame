/datum/master
	var/running = 0
	var/pause = 0
	var/system/systems
	var/system/processing_systems

/datum/master/New()
	world.log << "Initializing master system..."
	var/list/P = new
	var/list/Ss = new
	var/cat = 0
	systems = Ss
	processing_systems = P
	for (var/path in subtypesof(/system))
		var/system/S = new path()
		if (S.flags & S_INIT)
			world.log << "Initializing [S.name]"
			S.initialize()
		if (S.flags & S_PROCESS)
			world.log << "Processing [S.name]"
			cat += S.allocated_cpu
			P += S
		Ss[path] += S
	// CPU allocation normalisation
	for (var/system/S in P)
		S.allocated_cpu /= cat
	world.log << "Systems initialized."
	begin_process()
	. = ..()

/datum/master/proc/begin_process()
	set waitfor = 0

	running = 1
	while (1)
		if (pause)
			sleep(world.tick_lag)
			continue

		var/cpu_left = 100 - world.cpu
		if (cpu_left <= 1)
			world << "System overloaded, no CPU time left for systems."
		for (var/system/S in processing_systems)
			if (S.firing)
				S.allowed_cpu_time = cpu_left * S.allocated_cpu
				continue
			if (S.next_fire > world.time)
				continue
			S.next_fire = world.time + S.update_rate
			S.firing = 1
			S.allowed_cpu_time = cpu_left * S.allocated_cpu
			spawn()
				S.process()
				S.firing = 0

		sleep(world.tick_lag)