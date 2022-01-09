/system
	var/name = "name your damn systems"
	var/flags = 0
	var/update_rate = 10 // deciseconds
	var/priority = 0
	var/allowed_cpu_time = 0
	var/allocated_cpu = 0.3

	var/next_fire = 0
	var/firing = FALSE

/system/proc/initialize()

/system/proc/process()