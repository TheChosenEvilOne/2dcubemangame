/atom
	var/integrity
	var/max_integrity = 100
	var/rotatable = 0

/atom/New()
	. = ..()
	integrity = max_integrity

/atom/proc/destroy()
	del src

/atom/proc/take_damage(amount)
	integrity -= amount
	if (integrity <= 0)
		destroy()

/atom/proc/projectile_impact(atom/movable/projectile/P)
	take_damage(P.damage)

/atom/movable
	var/say_verb = "states"

/atom/movable/proc/p_possessive()
	switch (gender)
		if ("neuter") . = "itself"
		if ("male") . = "himself"
		if ("female") . = "herself"
		if ("plural") . = "themselves"

/atom/movable/proc/say(words)
	hearers() << "<b>[src]</b> [say_verb], \"[words]\""
	new /atom/movable/chat_message(src, words)

/atom/movable/proc/act(action)
	hearers() << "<i><b>[src]</b> [action].</i>"
	new /atom/movable/chat_message(src, "<i>[action]</i>")