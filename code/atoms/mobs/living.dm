/mob/living
	maptext_y = -20
	var/dead_state
	var/datum/ai/ai
	var/hud/status/status_hud // dunno, this seems like the best way of doing this.
	var/status = STATUS_ALIVE
	var/kill_mode = FALSE

/mob/living/initialize()
	. = ..()
	if (ai)
		ai = sys_ai.add_mob_ai(src, ai)
	status_hud = new /hud/status(src)

/mob/living/Login()
	. = ..()
	if (status == STATUS_DEAD)
		ghostize()

/mob/living/remove_huds()
	status_hud = null
	. = ..()

/mob/living/take_damage(amount)
	integrity -= amount
	if (status_hud)
		status_hud.change_health_colour(integrity / max_integrity)
	if (amount > 10)
		client?.glorf()
	update_maptext()
	if(!status && integrity <= 0)
		die()
	if(integrity < -max_integrity)
		destroy()

/mob/living/heal_damage(amount)
	. = ..()
	if (status_hud)
		status_hud.change_health_colour(integrity / max_integrity)
	update_maptext()

/mob/living/get_movement_delay(loc, dir, turf/T)
	if (!istype(T))
		return ..()
	return movement_delay + T.get_slowdown(src, dir)

/mob/living/proc/die()
	if (ai)
		sys_ai.remove_mob_ai(src)
	status = STATUS_DEAD
	density = FALSE
	layer = UNDER_MOB_LAYER
	icon_state = dead_state
	update_maptext()
	ghostize()

/mob/living/update_maptext()
	if(status)
		maptext = null
		return
	var/maptext_color
	var/health_percentage = round(integrity/max_integrity*100)
	switch(health_percentage)
		if(100 to INFINITY)
			maptext_color = "#00dd00"
		if(75 to 99)
			maptext_color = "#88bb00"
		if(50 to 74)
			maptext_color = "#aaaa00"
		if(25 to 49)
			maptext_color = "#bb8800"
		if(2 to 24)
			maptext_color = "#cc5500"
		if(-INFINITY to 1)
			maptext_color = "#dd0000"
	maptext = CENTERTEXT(MAPTEXT("[key ? "[name][client ? "" : " (DC)"]\n" : ""][SMALLTEXT("<font color='[maptext_color]'>[health_percentage]%</font>")]"))