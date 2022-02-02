/datum/ai_behaviour/wander

/datum/ai_behaviour/wander/update(datum/ai_state/S)
	S.mob.Move(get_step(S.mob, pick(ALL_DIRECTIONS + NONE)))