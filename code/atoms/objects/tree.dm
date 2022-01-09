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

/obj/item/wood/left_click(adjacent, params, obj/item)
	if(!adjacent)
		return
	if(istype(item, /obj/item/rock) && make_tool(item, /obj/item/pickaxe))
		return TRUE
	return ..()

/obj/item/wood/right_click(adjacent, params, obj/item)
	if(!adjacent)
		return
	if(istype(item, /obj/item/rock) && make_tool(item, /obj/item/sword))
		return TRUE
	return ..()

/obj/item/wood/proc/make_tool(obj/item/rock, path)
	new path(loc)
	rock.destroy()
	destroy()
	return TRUE
