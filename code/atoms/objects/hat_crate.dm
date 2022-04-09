// THIS IS A TEMPORARY OBJECT FOR TESTING, PLEASE REMOVE THIS ONCE IT IS UNNECCESSARY.

/obj/hat_crate
	name = "hat crate"
	icon_state = "crate"

/obj/hat_crate/left_click(adjacent)
	if (adjacent != WORLD_ADJACENT)
		return
	var/selection = input("Which hat do you want?") as null|anything in subtypesof(/obj/item/clothing/hat)
	if (!selection)
		return
	new selection(loc)
	destroy()