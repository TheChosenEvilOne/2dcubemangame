SYSTEM_CREATE(ai)
	name = "AI"
	flags = S_PROCESS
	update_rate = 1
	priority = 50
	var/list/datum/ai_behaviour/behaviours = list()
	var/list/datum/ai/processing = list()

/system/ai/process()
	for (var/P in processing)
		check_cpu
		var/datum/ai/A = processing[P]
		if (A.next_update <= world.time)
			A.next_update = world.time + A.update_rate
			A.update()

/system/ai/proc/add_mob_ai(mob/living/M, datum/ai/A)
	if (!(M && A))
		return
	var/datum/ai/ai = processing[A] ? processing[A] : (processing[A] = new A)
	ai.add_mob(M)
	return ai

/system/ai/proc/remove_mob_ai(mob/living/M)
	M.ai.remove_mob(M)

/system/ai/proc/create_behaviour(P)
	if (behaviours[P])
		return behaviours[P]
	return behaviours[P] = new P