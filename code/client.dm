/client
	fps = 60

/client/New()
	. = ..()
	if (usr) return
	src << "<h2>Hey, welcome to 2D cubemans</h2>"
	src << "The game is open source at: https://github.com/TheChosenEvilOne/2dcubemangame"
	src << "Your contributions are appreciated."
	world << "<b>[src]</b> has connected."


/client/Command(command)
	if (connection != "telnet")
		return ..()

/client/verb/who()
	set name = "Who"
	var msg = "<B>Players online:</B>\n"
	for (var/client/C)
		msg += "[C.key]\n"
	usr << msg

/client/verb/flip()
	set name = "Flip"
	animate(mob, transform = turn(matrix(), 120), time = 1.5, loop = 1)
	animate(transform = turn(matrix(), 240), time = 1.5)
	animate(transform = null, time = 1.5)

/client/verb/test()
	set name = "Test"
	experiment()