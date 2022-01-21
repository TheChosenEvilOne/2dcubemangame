/hud_object/button
	icon_state = "button"
	var/hud_object/icon/hicon = new()
	var/click_handler

/hud_object/button/setup()
	hicon.layer = layer+1
	hicon.screen_loc = screen_loc

/hud_object/button/remove()
	hicon = null

/hud_object/button/show(client/C)
	C.screen += hicon

/hud_object/button/hide(client/C)
	C.screen -= hicon

/hud_object/button/Click(location, control, params)
	if (click_handler)
		call_handler(click_handler, src, params)