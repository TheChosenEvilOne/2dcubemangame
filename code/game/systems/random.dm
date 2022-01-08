PROCESSING_CREATE(random)
	name = "random process"
	update_rate = 0
	var/update_ratio = 0.3 // how many percent to update every decisecond

/system/processing/random/process()
	for (var/datum/game_object/O as anything in processing)
		O.process()
		check_cpu