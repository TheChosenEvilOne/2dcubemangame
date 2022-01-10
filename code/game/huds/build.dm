/hud/build
	var/datum/builder/builder

/hud/build/New(mob, b)
	builder = b
	. = ..(mob)

/hud/build/remove()
	builder = null
	. = ..()

/hud/build/logout()
	owner.toggle_build(FALSE)

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
	B.hicon.transform.Scale(0.8)
	var/icon/buildicon = icon(initial(builder.build_type.icon), initial(builder.build_type.icon_state))
	buildicon.Scale(world.icon_size, world.icon_size)
	B.hicon.icon = buildicon
	B = new_object(/hud_object/button, "colour")
	B.name = "Colour"
	B.click_handler = .proc/change_colour
	B.screen_loc = "NORTH,WEST+2"
	B.hicon.icon_state = "color"

/hud/build/proc/change_type(hud_object/button/B, params)
	params = params2list(params)
	if (params["right"])
		owner.toggle_build()
		return
	var/atom/path = input(usr, "Select build type.") as null|anything in builder.buildable
	if (!path)
		return
	builder.build_type = path
	var/icon/buildicon = icon(initial(builder.build_type.icon), initial(builder.build_type.icon_state))
	buildicon.Scale(world.icon_size, world.icon_size)
	B.hicon.icon = buildicon

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
