/datum/master
	var/running = FALSE
	var/paused = FALSE
	var/allocated_cpu = 0
	var/system/systems
	var/system/processing_systems

/datum/master/proc/diagnostics()
	. = "<font size='4'><B>Master System Diagnostics</B></font>\n"
	. += "[master.paused ? "<B>Paused</B>" : "<B>Running</B>"]\n"
	. += "CPU: [round(world.cpu, 0.001)]\n"
	. += "Map CPU: [round(world.map_cpu, 0.001)]\n"
	. += "CPU allocated: [round(master.allocated_cpu, 0.001)]\n"
	. += "Time: [world.time]\n"
	for (var/system/S as anything in master.systems)
		S = master.systems[S]
		. += "<B>[S.name]</B>: [S.firing ? "\[FIRING\]":]\n"
		. += "\tFlags: [S.flags & S_INIT ? "INITIALIZE " :][S.flags & S_PROCESS ? "PROCESS " :][S.flags & S_PAUSED ? "PAUSED " :]\n"
		. += "\tPriority: [S.priority]\n"
		if (S.flags & S_PROCESS)
			. += "\tCPU allocation: [S.allocated_cpu]\n"
			. += "\tCPU threshold: [S.allowed_cpu_time]\n"
			. += "\tUpdate rate: [S.update_rate / 10] Hz\n"
			. += "\tNext update in: [round((S.next_fire - world.time) / 10, 0.01)] Seconds\n"
			if (istype(S, /system/processing))
				var/system/processing/P = S
				. += "\tProcessing: [P.processing.len] items\n"
		. += S.diagnostics()
	return .

/datum/master/proc/setup()
	world.log << "Initializing master system..."
	var/list/system/sorted = new
	for (var/path in subtypesof(/system))
		var/system/S = new path()
		var/inserted = FALSE
		for (var/I in 1 to sorted.len)
			if (S.priority > sorted[I].priority)
				continue
			sorted.Insert(I, S)
			inserted = TRUE
			break
		if (!inserted)
			sorted += S

	var/list/P = new
	var/list/Ss = new
	var/cat = 0
	systems = Ss
	processing_systems = P
	for (var/system/S in sorted)
		if (S.flags & S_INIT)
			world.log << "Initializing [S.name]"
			S.initialize()
		if (S.flags & S_PROCESS)
			world.log << "Processing [S.name]"
			cat += S.allocated_cpu
			P += S
		Ss[S.type] = S
	// CPU allocation normalisation
	for (var/system/S in P)
		S.allocated_cpu /= cat
	world.log << "Systems initialized."
	begin_process()
	. = ..()

/datum/master/proc/begin_process()
	set waitfor = FALSE

	running = TRUE
	while (TRUE)
		if (paused)
			sleep(world.tick_lag)
			continue

		var/cpu_left = 100 - world.cpu - allocated_cpu
		if (cpu_left <= 1)
			world << "System overloaded, no CPU time left for systems."
		for (var/system/S in processing_systems)
			if (S.flags & S_PAUSED)
				continue

			if (S.firing)
				allocated_cpu -= S.allowed_cpu_time
				S.allowed_cpu_time = cpu_left * S.allocated_cpu
				allocated_cpu += S.allowed_cpu_time
				continue
			if (S.next_fire > world.time)
				continue
			S.next_fire = world.time + S.update_rate
			S.firing = TRUE
			S.allowed_cpu_time = cpu_left * S.allocated_cpu
			allocated_cpu += S.allowed_cpu_time
			call_process(S)
		sleep(world.tick_lag)

/datum/master/proc/call_process(system/S)
	set waitfor = FALSE

	S.process()
	S.firing = FALSE
	allocated_cpu -= S.allowed_cpu_time