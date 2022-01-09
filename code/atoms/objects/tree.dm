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
	desc = "wood for crafting. slap rocks on it with left click to make pickaxe, or right click to make sword"
	icon_state = "wood"

/obj/item/wood/left_click(adjacent, params)
	if (!adjacent)
		return
	if (!istype(usr, /mob/living/inventory))
		return
	var/mob/living/inventory/M = usr
	if(make_tool(M.inventory, /obj/item/pickaxe))
		return TRUE
	return ..()

/obj/item/wood/right_click(adjacent, params)
	if (!adjacent)
		return
	if (!istype(usr, /mob/living/inventory))
		return
	var/mob/living/inventory/M = usr
	if(make_tool(M.inventory, /obj/item/sword))
		return TRUE
	return ..()

/obj/item/wood/proc/make_tool(datum/inventory/inventory, path)
	var/obj/item/rock/rock = inventory.slots[inventory.selected_slot].item
	if(!istype(rock))
		return FALSE
	new path(inventory.parent.loc)
	inventory.drop_item(inventory.selected_slot)
	del(rock)
	del(src)
	return TRUE
