// remove this once config loading is a thing.
var/global/list/admins = list("thechosenevilone")
var/global/list/averbs

/proc/load_admin_verbs()
	averbs = list()
	var/types = typesof(/admin_verbs)
	for (var/P in types)
		var/admin_verbs/V = P
		averbs[initial(V.name)] = typesof("[P]/proc")

/proc/load_admin(client/C)
	// load adminrank here.
	if (!(C.ckey in admins))
		return null
	return new /datum/admin(C, list("admin", "fun"))

/datum/admin
	var/client/client
	var/verbs = list()

/datum/admin/New(client/C, list/perms)
	client = C
	for (var/V in perms)
		verbs += averbs[V]
	C.verbs += verbs
	..()

/client/proc/readmin()
	set name = "Re-admin"
	set category = "Admin"
	verbs -= .proc/readmin
	verbs += admin.verbs

/datum/admin/proc/deadmin()
	client.verbs -= verbs
	client.verbs += /client.proc/readmin