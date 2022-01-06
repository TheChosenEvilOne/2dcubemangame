/obj/item
	name = "item"
	desc = "item"
	icon = 'icons/items.dmi'
	layer = ITEM_LAYER

/obj/item/left_click(adjacent, params)
	if (!adjacent)
		return
	if (!istype(usr, /mob/inventory))
		return
	var/mob/inventory/M = usr
	if (!M.inventory.selected_slot)
		return
	M.inventory.insert_item(src, M.inventory.selected_slot)

/obj/item/proc/use()

/obj/item/proc/attack_self()

/obj/item/proc/attack_left(atom/target, adjacent, params)

/obj/item/proc/attack_right(atom/target, adjacent, params)
