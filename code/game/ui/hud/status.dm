/hud/status

/hud/status/create_hud(mob)
	var/hud_object/button/B

	B = new_object(/hud_object/button, "kill")
	B.name = "KILL"
	B.click_handler = .proc/kill
	B.screen_loc = "SOUTH,EAST"
	B.hicon.icon_state = "KILL0"

/hud/status/proc/kill(hud_object/button/B, params)
	var/mob/living/L = owner
	if (!istype(L)) // sanity, shouldn't happen though.
		return
	L.kill_mode = !L.kill_mode
	B.hicon.icon_state = "KILL[L.kill_mode]"
	L.update_appearance()