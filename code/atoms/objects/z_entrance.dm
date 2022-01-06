/obj/z_entrance
	name = "cave entrance"
	icon_state = "cave_entrance"
	var/Z = 2

/obj/z_entrance/left_click(adjacent)
	if (!adjacent)
		return
	if (world.maxz < Z)
		world.maxz = Z
	var/T = locate(usr.x, usr.y, z == Z ? 1 : Z)
	usr.Move(T)