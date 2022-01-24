/datum/ai
	var/update_rate = 5 // Can be updated by behaviours
	var/list/mobs = list()
	var/list/states = list()
	var/list/behaviours
	var/next_update = 0

/datum/ai/New()
	. = ..()
	// Not ideal, but will do.
	var/list/B = list()
	for (var/P in behaviours)
		B[sys_ai.create_behaviour(P)] = behaviours[P]
	behaviours = B

/datum/ai/proc/add_mob(mob/M)
	if (M in mobs)
		return
	var/datum/ai_state/S = new
	mobs[M] = S
	S.mob = M
	states += S

/datum/ai/proc/remove_mob(mob/M)
	if (M in mobs)
		var/S = mobs[M]
		states -= S
		mobs -= M

/datum/ai/proc/update()
	for (var/datum/ai_state/S in states)
		if (S.next_behaviour_select <= world.time)
			var/datum/ai_behaviour/B = pick(behaviours)
			S.current_behaviour = B
			S.next_behaviour_select = world.time + rand(B.active_time_min, B.active_time_max)
		S.current_behaviour.update(S)

/datum/ai/wander
	behaviours = list(
		/datum/ai_behaviour/wait = 2,
		/datum/ai_behaviour/wander = 1
	)