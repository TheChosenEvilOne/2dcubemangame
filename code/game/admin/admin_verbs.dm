var/global/list/averbs = list()

/proc/register_admin_verb(group, id, path)
	if (averbs[group])
		if (averbs[group][id])
			CRASH("Admin verb [id] defined twice.")
		averbs[group][id] = path
		return
	averbs[group] = list(id = path)

/proc/admin_permission_check(group, id)
	var/client/C = usr.client
	if (!C || !C.admin)
		return FALSE
	if (!C.admin.permissions[group])
		return (group in C.admin.permissions)
	return TRUE

ADMIN_VERB(admin, deadmin, De-admin)
	usr.client.admin.deadmin()