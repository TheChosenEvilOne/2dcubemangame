/obj/item
	name = "item"
	desc = "item"
	icon = 'icons/items.dmi'
	layer = ITEM_LAYER
	var/inventory_slot/slot

/obj/item/destroy()
	if (slot)
		slot.remove_item()
	. = ..()

/obj/item/left_click(adjacent, params, obj/item)
	if (adjacent != WORLD_ADJACENT)
		return
	if (!istype(usr, /mob/living/inventory))
		return
	var/mob/living/inventory/M = usr
	if (!M.inventory.selected_slot)
		return
	M.inventory.insert_item(src, M.inventory.selected_slot)

/obj/item/proc/inserted(datum/inventory/I, slot)

/obj/item/proc/dropped(datum/inventory/I, slot)

/obj/item/proc/removed(datum/inventory/I, slot)

/obj/item/proc/attack_self()

/obj/item/proc/attack_left(atom/target, adjacent, params)

/obj/item/proc/attack_right(atom/target, adjacent, params)
