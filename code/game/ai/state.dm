/datum/ai_state
	var/mob/mob
	var/next_behaviour_select = 0
	var/datum/ai_behaviour/current_behaviour
	var/list/data = list()

/datum/ai_state/proc/operator[](idx)
	return data[idx]

/datum/ai_state/proc/operator[]=(idx, B)
	data[idx] = B