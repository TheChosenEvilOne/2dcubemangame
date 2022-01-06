/hud/build
	var/datum/builder/builder

/hud/build/New(mob, b)
	builder = b
	. = ..(mob)

/hud/build/remove()
	builder = null

/hud/build/create_hud()
	var/hud_object/button/B

	B = new_object(/hud_object/button, "mode")
	B.name = "Builder Mode"
	B.click_handler = .proc/change_mode
	B.screen_loc = "NORTH,WEST"
	B.hicon.icon_state = "build"

	B = new_object(/hud_object/button, "type")
	B.name = "Building type"
	B.click_handler = .proc/change_type
	B.screen_loc = "NORTH,WEST+1"
	B.hicon.icon = initial(builder.build_type.icon)
	B.hicon.icon_state = initial(builder.build_type.icon_state)

	B = new_object(/hud_object/button, "colour")
	B.name = "Colour"
	B.click_handler = .proc/change_colour
	B.screen_loc = "NORTH,WEST+2"

/hud/build/proc/change_type(location, control, params)
	params = params2list(params)
	if (params["right"])
		owner.client.toggle_build()
		return
	var/atom/path = input(usr, "Select build type.") as null|anything in builder.buildable
	if (!path)
		return
	builder.build_type = path
	ui_objects["type"].hicon.icon = initial(path.icon)
	ui_objects["type"].hicon.icon_state = initial(path.icon_state)

/hud/build/proc/change_mode(location, control, params)
	params = params2list(params)
	if (params["right"])
		owner.client.toggle_build()
		return

	if (builder.mode == BUILDING)
		usr << "Painting mode"
		builder.mode = PAINTING
		ui_objects["mode"].hicon.icon_state = "paint"
	else
		usr << "Building mode"
		builder.mode = BUILDING
		ui_objects["mode"].hicon.icon_state = "build"


/hud/build/proc/change_colour(location, control, params)
	params = params2list(params)
	if (params["right"])
		owner.client.toggle_build()
		return

	builder.colour = input("Select colour") as color
	ui_objects["colour"].color = builder.colour
