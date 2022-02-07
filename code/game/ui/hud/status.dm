/hud/status

/hud/status/create_hud(mob)
	var/hud_object/button/B
	B = new_object(/hud_object/button, "kill")
	B.name = "KILL"
	B.click_handler = .proc/kill
	B.screen_loc = "EAST,SOUTH"
	B.hicon.icon_state = "KILL0"

	var/hud_object/icon/I
	I = new_object(/hud_object/icon, "health")
	I.icon_state = "health"
	I.screen_loc = "EAST,CENTER"
	I.color = "#00FF00"

// using ui_objects feels like a bit of an awful way of doing this, but dunno.
/hud/status/proc/change_health_colour(percent)
	ui_objects["health"].color = rgb((1 - percent) * 512, percent * 512, 0)

/hud/status/proc/kill(hud_object/button/B, params)
	var/mob/living/L = owner
	if (!istype(L)) // sanity, shouldn't happen though.
		return
	L.kill_mode = !L.kill_mode
	B.hicon.icon_state = "KILL[L.kill_mode]"
	L.update_appearance()