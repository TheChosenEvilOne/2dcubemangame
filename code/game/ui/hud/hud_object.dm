/hud_object
	var/hud/hud
	var/id
	var/value
	parent_type = /atom/movable
	name = "FUCK FUCK FUCK"
	icon = 'icons/hud.dmi'
	plane = UI_PLANE

/hud_object/New(H)
	hud = H

/hud_object/Click(location, control, params)
	return

/hud_object/proc/call_handler(handler)
	// BYOND sadly doesn't have a way to pass rest of the arguments in a list
	// so using args - handler will have to do.
	call(hud, handler)(arglist(args - handler))

/hud_object/proc/remove()

/hud_object/proc/setup()

/hud_object/proc/show(client/C)

/hud_object/proc/hide(client/C)
