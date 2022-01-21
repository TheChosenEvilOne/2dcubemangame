ADMIN_VERB(admin, kick, Kick)
	var/player = input("Who to kick?") as null|anything in clients
	if (!player)
		return
	del(player)

ADMIN_VERB(admin, spawnatom, Spawn Atom)
	var/path = text2path(input("Type path", "Spawn Atom") as text|null)
	if (!path)
		return
	new path(usr.loc)

ADMIN_VERB(admin, masterdiagonistics, Master System Diagnostics)
	usr << master.diagnostics()