PROCESSING_CREATE(random)
	name = "random process"
	update_rate = 1
	var/update_ratio = 0.1

/system/processing/random/process()
	if (!processing.len)
		return
	var/amount = processing.len * update_ratio
	if (amount < 1)
		sleep(amount)
		amount = 1
	for (var/i in 1 to round(amount))
		var/datum/game_object/O = pick(processing)
		O.process()
		check_cpu