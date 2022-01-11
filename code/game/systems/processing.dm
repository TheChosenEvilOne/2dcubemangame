SYSTEM_CREATE(processing)
	name = "processing"
	flags = S_PROCESS
	priority = 15
	var/list/processing = list()

/system/processing/process()
	for (var/datum/game_object/O as anything in processing)
		check_cpu
		O.process()

/system/processing/proc/start_processing(datum/game_object/O)
	if (O.datum_flags & DATUM_PROCESSING)
		return
	O.datum_flags |= DATUM_PROCESSING
	processing += O

/system/processing/proc/stop_processing(datum/game_object/O)
	if (!(O.datum_flags & DATUM_PROCESSING))
		return
	O.datum_flags &= ~DATUM_PROCESSING
	processing -= O