/admin_verbs/admin
	name = "admin"

/admin_verbs/admin/proc/kick()
	set name = "Kick"
	set category = "Admin"
	var/player = input("Who to kick?") as null|anything in clients
	if (!player)
		return
	del(player)

/admin_verbs/admin/proc/spawn_atom(path as text)
	set name = "Spawn"
	set category = "Admin"
	path = text2path(path)
	if (!path)
		return
	new path(usr.loc)