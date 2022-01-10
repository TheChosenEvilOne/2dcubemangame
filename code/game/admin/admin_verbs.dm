/admin_verbs
	var/name = ""

/admin_verbs/proc/deadmin()
	set name = "Deadmin"
	set category = "Admin"
	usr.client.admin.deadmin()