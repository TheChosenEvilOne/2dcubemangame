PROCESSING_CREATE(random)
	name = "random process"
	update_rate = 1
	priority = 100
	var/avg_rate = 6 // tick average between game object processing.

/system/processing/random/process()
	var/amount = processing.len / avg_rate
	if (!amount)
		return
	if (amount < avg_rate)
		sleep(avg_rate / amount * update_rate)
		if (!processing.len)
			return
	for (var/i in 1 to ceil(amount, 1))
		check_cpu
		var/datum/game_object/O = pick(processing)
		O.process()
