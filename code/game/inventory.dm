/inventory_slot
	var/id
	var/name = "Inventory Slot"
	var/screen_loc = "0,0"
	var/selectable = 0
	var/datum/inventory/inventory
	var/obj/item/item

/inventory_slot/l_hand
	id = "lhand"
	name = "left hand"
	screen_loc = "SOUTH,CENTER-0.5"

/inventory_slot/r_hand
	id = "rhand"
	name = "right hand"
	screen_loc = "SOUTH,CENTER+0.5"

/datum/inventory
	var/parent
	var/selected_slot
	var/hud/inventory/hud
	var/list/inventory_slot/slots

/datum/inventory/New(mob/mob)
	hud = new(mob)
	parent = mob
	for (var/P in slots)
		slots -= P
		var/inventory_slot/S = new P
		S.inventory = src
		slots[S.id] = S
		var/hud_object/slot/O = hud.new_object(/hud_object/slot, S.id)
		O.name = S.name
		O.slot = S
		O.screen_loc = S.screen_loc
		O.setup()
		if (!selected_slot)
			selected_slot = S.id
			O.icon_state = "slot_a"
	hud.show()
	mob.click_intercept[src] = .proc/click_handler

/datum/inventory/proc/remove()
	for (var/P in slots)
		drop_item(P)
		var/inventory_slot/S = slots[P]
		S.inventory = null
		del S
	slots.Cut()
	hud.remove()

/datum/inventory/proc/click_handler(atom/object, location, control, params)
	if (!slots[selected_slot].item)
		return 0
	var/obj/item/I = slots[selected_slot].item
	if (object == I)
		I.attack_self()
		return 0
	if (object.loc == null)
		return 0
	var/A = get_dist(usr, object) <= usr.interact_range
	if (params["left"])
		I.attack_left(object, A, params)
	if (params["right"])
		I.attack_right(object, A, params)
	return 1

/datum/inventory/proc/update()
	for (var/P in slots)
		hud.ui_objects[P].update_item()

/datum/inventory/proc/insert_item(obj/item/I, slot)
	if (slots[slot].item)
		return 0
	I.loc = null
	slots[slot].item = I
	hud.ui_objects[slot].update_item()
	return 1

/datum/inventory/proc/remove_item(slot)
	if (!slots[slot].item)
		return 0
	var/obj/item/I = slots[slot].item
	slots[slot].item = null
	hud.ui_objects[slot].update_item()
	return I

/datum/inventory/proc/drop_item(slot)
	var/obj/item/I = remove_item(slot)
	if (!I)
		return 0
	I.loc = usr.loc

/datum/inventory/player
	slots = list(
		/inventory_slot/l_hand,
		/inventory_slot/r_hand
	)