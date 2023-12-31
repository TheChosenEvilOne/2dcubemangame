/obj/tree
	name = "tree"
	desc = "a woody tree"
	icon = 'icons/32x64.dmi'
	icon_state = "tree"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/tree/destroy()
	new /obj/item/wood(loc)
	return ..()

/obj/tree/palm
	name = "palm tree"
	desc = "it has coconuts!"
	icon_state = "tree_palm"

/obj/tree/palm/destroy()
	new /obj/item/coconut(loc)
	return ..()