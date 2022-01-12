var/global/list/spawn_list = list(
	/obj/item/gun,
	/obj/item/wrench,
	/obj/item/pickaxe,
	/obj/item/sword,
	/obj/item/beer,
	/obj/item/injector,
	/obj/item/wood,
	/obj/item/rock,
	/obj/item/brush,
	/obj/item/canvas,
	/obj/item/magnifying_glass,
	/obj/item/padlock,
	/obj/hat_crate,
	/obj/sign,
	/obj/cannon,
	/obj/respawn_station,
	/obj/z_entrance/hole,
	/obj/z_entrance/ladder,
	/obj/boombox
)

/proc/experiment()
	var/function = input("function") as null|anything in list("item", "map gen", "test")
	switch (function)
		if ("item")
			var/select = input("h") as null|anything in spawn_list
			if (!select)
				return
			new select(usr.loc)
		if ("map gen")
			var/select = input("h") as null|anything in (typesof(/datum/map_generator) - /datum/map_generator)
			if (!select)
				return
			var/datum/map_generator/G = new select()
			G.configure()
			world << "[usr] generating map at [usr.x] [usr.y] [usr.z], [select]"
			G.generate(usr.x, usr.y, usr.z)
		if ("test")
			test2()

/proc/test2()
	for (var/r in 1 to input("radius") as num)
		var/list/C = circle(usr.x, usr.y, r)
		for (var/i in 1 to C.len step 2)
			locate(C[i], C[i+1], usr.z).color = "red"