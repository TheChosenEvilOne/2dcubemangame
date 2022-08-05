/proc/load_admin(client/C)
	var/admins = GET_CONF("admins")
	var/ranks = GET_CONF("ranks")
	// load adminrank here.
	if (!(C.ckey in admins))
		return null
	return new /datum/admin(C, ranks[admins[C.ckey]])

/datum/admin
	var/client/client
	var/permissions = list()
	var/verbs = list()

/datum/admin/New(client/C, list/perms)
	client = C
	permissions = perms
	for (var/V in perms)
		if (perms[V])
			for (var/id in perms[V])
				verbs += averbs[V][id]
		else
			for (var/id in averbs[V])
				verbs += averbs[V][id]
	C.verbs += verbs
	..()

// Tiz som prety speciel cood
/client/proc/readmin()
	set name = "Re-admin"
	set category = "admin"
	verbs -= .proc/readmin
	verbs += admin.verbs

/datum/admin/proc/deadmin()
	client.verbs -= verbs
	client.verbs += /client.proc/readmin