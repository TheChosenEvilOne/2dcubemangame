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

/obj/item/wood
	name = "wood"
	desc = "wood for crafting, slap a rock with it."
	icon_state = "wood"