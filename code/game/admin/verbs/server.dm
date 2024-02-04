ADMIN_VERB(server, runtime, List Runtimes)
	usr << "The following runtimes have occurred:"
	for (var/exception/E in exceptions)
		usr << E.desc

ADMIN_VERB(server, restart, Restart)
	var/answer = alert("Are you sure you want to restart?", "Server Reboot", "Yes", "No")
	if (answer == "Yes")
		world << "Reboot initiated by [usr]."
		world.Reboot()