/mob
	maptext_y = -12
	maptext_x = -112
	maptext_width = 256
	icon = 'icons/mobs.dmi'
	say_verb = "says"
	var/interact_range = 45.5 // close enough to sqrt(2) * 32
	var/can_interact = TRUE

/mob/initialize()
	. = ..()
	update_maptext()

/mob/destroy()
	ghostize()
	. = ..()

/mob/living/Login()
	. = ..()
	update_maptext()

/mob/living/Logout()
	. = ..()
	update_maptext()

/mob/proc/update_maptext()
	return

/mob/proc/update_name(N)
	name = N
	update_maptext()

/mob/proc/set_player(P)
	if (istype(P, /mob))
		var/mob/M = P
		if (!M.key || !M.client)
			return FALSE
		world << "???"
		M.remove_huds()
		update_name(M.key)
		ckey = M.ckey
		return TRUE
	else if (istext(P))
		if (clients[P])
			var/client/C = clients[P]
			C.mob.remove_huds()
			ckey = C.ckey
			update_name(C.key)
			return TRUE
		ckey = P
		update_name(key)
		return TRUE
	else if (istype(P, /client))
		var/client/C = P
		C.mob.remove_huds()
		ckey = C.ckey
		update_name(C.key)
		return TRUE
	return FALSE

/mob/proc/ghostize()
	if (!ckey)
		return
	var/mob/dead/ghost/G = new (loc)
	G.set_player(src)
