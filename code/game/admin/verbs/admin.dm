ADMIN_VERB(admin, kick, Kick)
	var/player = input("Who to kick?") as null|anything in clients
	if (!player)
		return
	player = clients[player]
	del(player)

ADMIN_VERB(admin, ban, Ban)
	var/client/player = input("Who to ban?") as null|anything in clients
	if (!player)
		return
	player = clients[player]
	if (player.admin)
		usr << "Sorry, banning admins isn't allowed."
		return
	var/reason = input("Ban reason?") as null|text
	world.SetConfig("ban",ckey(player.key),"reason=[reason];admin=[usr.ckey]")
	del(player)

ADMIN_VERB(admin, spawnatom, Spawn Atom)
	var/path = text2path(input("Type path", "Spawn Atom") as text|null)
	if (!path)
		return
	new path(usr.loc)

ADMIN_VERB(admin, asay, Admin Say)
	var/text = input("Admin Say", "Admin Say") as text|null
	if (!text)
		return
	for (var/client/c as anything in sys_vars.admins)
		c << output("<b>[usr.client.key]</b>: [text]", "special")

ADMIN_VERB(admin, masterdiagonistics, Master System Diagnostics)
	usr << master.diagnostics()