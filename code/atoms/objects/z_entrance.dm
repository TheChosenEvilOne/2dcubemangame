/obj/z_entrance
	name = "cave entrance"
	icon_state = "cave_entrance"
	interactable = TRUE
	var/z_dir = 0

/obj/z_entrance/interact(mob/who)
	if (!z_dir || z + z_dir < 1)
		return
	// arbitrary number
	if (z + z_dir > 8)
		who << "You feel like you shouldn't go deeper."
		return
	if (world.maxz < z + z_dir)
		world.maxz = z + z_dir
	var/T = locate(x, y, z + z_dir)
	who.Move(T)

/obj/z_entrance/ladder
	name = "ladder"
	icon_state = "ladder"
	z_dir = -1

/obj/z_entrance/hole
	name = "hole"
	icon_state = "hole"
	z_dir = 1