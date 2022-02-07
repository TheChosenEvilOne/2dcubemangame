/hud/lobby

/hud/lobby/create_hud(mob, b)
	var/hud_object/icon/I = new_object(/hud_object/icon, "image")
	I.screen_loc = "WEST,SOUTH"
	if (!sys_vars.lobby_image)
		sys_vars.lobby_image = new /icon("images/lobby/[pick(flist("images/lobby/"))]")
		var/S = (world.view * 2 + 1) * world.icon_size
		sys_vars.lobby_image.Scale(S, S)
	I.icon = sys_vars.lobby_image

	var/hud_object/button/B = new_object(/hud_object/button, "join")
	B.name = "Join"
	B.screen_loc = "CENTER-0.5,SOUTH"
	B.icon = 'icons/64x32.dmi'
	B.icon_state = "join"
	B.click_handler = .proc/join

/hud/lobby/proc/join(hud_object/button/B)
	var/mob/dead/new_player/D = usr
	new /mob/living/inventory/player(locate(1, 1, 1)).set_player(D)
	D.destroy()