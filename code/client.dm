/client
	fps = 60
	var/datum/admin/admin
	var/list/plane/planes = list()

/client/New()
	if (!mob)
		src << "<h2>Hey, welcome to 2D cubemans</h2>"
		src << "The game is open source at: https://github.com/TheChosenEvilOne/2dcubemangame"
		src << "Your contributions are appreciated."
		world << "<b>[src]</b> has connected."
	else
		world << "<b>[src]</b> has reconnected."
	. = ..()
	clients[ckey] = src
	for (var/P in (typesof(/plane) - /plane))
		var/plane/plane = new P
		planes[P] = plane
		screen += plane
	admin = load_admin(src)
	if (admin)
		sys_vars.admins += src

/client/Del()
	clients -= ckey
	if (admin)
		sys_vars.admins += src
	if (mob)
		mob.hide_huds(TRUE)
	. = ..()

/client/AllowUpload(filename, size)
	if(size > 2097152)
		src << "[filename] is too large, maximum is 2 MiB."
		return FALSE
	return TRUE

/client/verb/who()
	set name = "Who"
	var msg = "<B>Players online:</B>\n"
	for (var/client/C)
		msg += "[C.key][C.admin ? " - [C.admin.rank_name]" : ""]\n"
	usr << msg

/client/verb/interact()
	set name = "Interact"

	if (!mob.can_interact)
		return
	
	for (var/d in list(mob.dir, 0))
		var/turf/T = get_step(mob, d)
		if (!T) continue
		var/stuff = T.contents + T

/client/verb/flip()
	set name = "Flip"
	animate(mob, transform = turn(matrix(), 120), time = 1.5, loop = 1, flags = ANIMATION_PARALLEL)
	animate(transform = turn(matrix(), 240), time = 1.5)
	animate(transform = null, time = 1.5)

/client/verb/test()
	set name = "Test"
	experiment()

/client/verb/hide_ui()
	set name = "Hide UI"

	var/plane/UI = planes[/plane/ui]
	UI.alpha = UI.alpha == 255 ? 0 : 255
