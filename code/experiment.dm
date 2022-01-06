/proc/experiment()
	var/function = input("function") as null|anything in list("item", "map gen")
	switch (function)
		if ("item")
			var/select = input("h") as null|anything in list(/obj/item/gun, /obj/item/wrench, /obj/item/pickaxe, /obj/item/sword, /obj/item/beer, /obj/cannon, /obj/respawn_station, /obj/z_entrance)
			if (!select)
				return
			new select(usr.loc)
		if ("map gen")
			var/select = input("h") as null|anything in (typesof(/datum/map_generator) - /datum/map_generator)
			if (!select)
				return
			world << "[usr] generating map at [usr.x] [usr.y] [usr.z], [select]"
			var/datum/map_generator/G = new select()
			G.generate(usr.x, usr.y, usr.z)