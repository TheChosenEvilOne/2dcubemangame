/hud/build
	var/icon_list = list()
	var/hud/scroll_list/list
	var/datum/builder/builder

/hud/build/remove()
	list.remove()
	list = null
	builder = null
	. = ..()

/hud/build/hide(logout)
	list.hide()
	if(logout)
		owner.toggle_build(FALSE)
	..()

/hud/build/create_hud(mob, b)
	builder = b
	var/build_list = list()
	for (var/atom/P as anything in builder.buildable)
		var/icon/I = new /icon(initial(P.icon), initial(P.icon_state))
		I.Scale(32, 32)
		icon_list["[P]"] = I
		build_list += list(list(I, initial(P.name), P))
	list = new /hud/scroll_list(usr, 6, 6, src, .proc/select, build_list)
	list.show_on_login = FALSE
	var/hud_object/button/B

	B = new_object(/hud_object/button, "mode")
	B.name = "Builder Mode"
	B.click_handler = .proc/change_mode
	B.screen_loc = "WEST,NORTH"
	B.hicon.icon_state = "build"

	B = new_object(/hud_object/button, "type")
	B.name = "Building type"
	B.click_handler = .proc/change_type
	B.screen_loc = "WEST+1,NORTH"
	B.hicon.transform *= 0.75
	B.hicon.icon = initial(builder.build_type.icon)
	B.hicon.icon_state = initial(builder.build_type.icon_state)

	B = new_object(/hud_object/button, "colour")
	B.name = "Colour"
	B.click_handler = .proc/change_colour
	B.screen_loc = "WEST+2,NORTH"
	B.hicon.icon_state = "color"

	B = new_object(/hud_object/button, "direction")
	B.name = "Direction"
	B.click_handler = .proc/change_direction
	B.screen_loc = "WEST+3,NORTH"
	B.hicon.icon_state = "direction"

/hud/build/proc/change_type(hud_object/button/B, params)
	params = params2list(params)
	if (params["right"])
		owner.toggle_build()
		return
	list.show()

/hud/build/proc/select(atom/value)
	list.hide()
	var/hud_object/button/B = ui_objects["type"]
	B.hicon.icon = icon_list["[value]"]
	builder.build_type = value

/hud/build/proc/change_mode(hud_object/button/B, params)
	params = params2list(params)
	if (params["right"])
		owner.toggle_build()
		return

	if (builder.mode == BUILDING)
		usr << "Painting mode"
		builder.mode = PAINTING
		B.hicon.icon_state = "paint"
	else
		usr << "Building mode"
		builder.mode = BUILDING
		B.hicon.icon_state = "build"

/hud/build/proc/change_colour(hud_object/button/B, params)
	params = params2list(params)
	if (params["right"])
		owner.toggle_build()
		return

	builder.colour = input("Select colour") as color
	B.hicon.color = builder.colour

/hud/build/proc/change_direction(hud_object/button/B, params)
	params = params2list(params)
	if (params["right"])
		owner.toggle_build()
		return

	if (B.hicon.dir == WEST)
		B.hicon.dir = NORTH
	else
		B.hicon.dir = (B.hicon.dir << 1) & 0xF
	builder.direction = B.hicon.dir