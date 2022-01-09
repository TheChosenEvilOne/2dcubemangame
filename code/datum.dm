/datum/game_object
	var/datum_flags = 0
	var/processing_system = /system/processing

/datum/game_object/New()
	if (master && master.running)
		initialize(FALSE)
	. = ..()

/datum/game_object/proc/initialize(start)
	if (datum_flags & DATUM_PROCESS && ispath(processing_system, /system/processing))
		master.systems[processing_system].start_processing(src)

/datum/game_object/proc/destroy()
	if (datum_flags & DATUM_PROCESSING)
		master.systems[processing_system].stop_processing(src)

/datum/game_object/proc/process()
	return
