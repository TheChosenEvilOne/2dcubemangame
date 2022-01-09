/obj/tree
	name = "tree"
	desc = "a woody tree"
	icon_state = "tree"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/tree/destroy()
	new /obj/item/wood(loc)
	return ..()

/obj/item/wood
	name = "wood"
	desc = "wood for crafting. slap rocks on it with left click to make pickaxe, or right click to make sword"
	icon_state = "wood"

/obj/item/wood/left_click(adjacent, params)
	if (!adjacent)
		return
	if (!istype(usr, /mob/living/inventory))
		return
	var/mob/living/inventory/M = usr
	make_tool(M.inventory, /obj/item/pickaxe)

/obj/item/wood/right_click(adjacent, params)
	if (!adjacent)
		return
	if (!istype(usr, /mob/living/inventory))
		return
	var/mob/living/inventory/M = usr
	make_tool(M.inventory, /obj/item/sword)

/obj/item/wood/proc/make_tool(datum/inventory/inventory, path)
	if(!istype(inventory.selected_slot, /obj/item/rock))
		return
	new path(inventory.parent.loc)
