/datum/ai_behaviour/wander

/datum/ai_behaviour/wander/update(datum/ai_state/S)
	step(S.mob, pick(ALL_DIRECTIONS + NONE))