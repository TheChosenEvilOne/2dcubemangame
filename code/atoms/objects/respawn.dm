/obj/respawn_station
	name = "respawn station"
	desc = "gamers don't die, they respawn."
	icon_state = "respawn"

/mob/ghost/New()
	..()
	click_intercept[src] = .proc/click_intercept

/mob/ghost/proc/click_intercept(atom/object, location, control, params)
	if (!istype(object, /obj/respawn_station))
		return 0
	var/mob/inventory/player/P = new (location)
	P.name = client.key
	P.ckey = ckey
	del src