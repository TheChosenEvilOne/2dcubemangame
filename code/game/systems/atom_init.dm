SYSTEM_CREATE(atom_init)
	name = "atom initialize"
	flags = S_INIT
	priority = 10

/system/atom_init/initialize()
	for (var/datum/game_object/A as anything in world)
		A.initialize(TRUE)