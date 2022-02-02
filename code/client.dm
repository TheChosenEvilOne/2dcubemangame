/client
	fps = 60
	var/datum/admin/admin
	var/list/plane/planes = list()

/client/New()
	. = ..()
	clients[ckey] = src
	for (var/P in (typesof(/plane) - /plane))
		var/plane/plane = new P
		planes[P] = plane
		screen += plane
	admin = load_admin(src)
	if (!usr)
		src << "<h2>Hey, welcome to 2D cubemans</h2>"
		src << "The game is open source at: https://github.com/TheChosenEvilOne/2dcubemangame"
		src << "Your contributions are appreciated."
		world << "<b>[src]</b> has connected."
		return
	else
		world << "<b>[src]</b> has reconnected."

/client/Del()
	clients -= ckey
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
		msg += "[C.key]\n"
	usr << msg

/client/verb/flip()
	set name = "Flip"
	animate(mob, transform = turn(matrix(), 120), time = 1.5, loop = 1, flags = ANIMATION_PARALLEL)
	animate(transform = turn(matrix(), 240), time = 1.5)
	animate(transform = null, time = 1.5)

/client/verb/test()
	set name = "Test"
	experiment()