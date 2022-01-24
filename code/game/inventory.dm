/inventory_slot
	var/id
	var/icon
	var/name = "Inventory Slot"
	var/screen_loc = "0,0"
	var/selectable = FALSE
	var/datum/inventory/inventory
	var/obj/item/item

/inventory_slot/proc/remove_item()
	return inventory.remove_item(id)

/inventory_slot/l_hand
	id = "lhand"
	icon = "lhand"
	name = "left hand"
	screen_loc = "SOUTH,CENTER-0.5"
	selectable = TRUE

/inventory_slot/r_hand
	id = "rhand"
	icon = "rhand"
	name = "right hand"
	screen_loc = "SOUTH,CENTER+0.5"
	selectable = TRUE

/inventory_slot/hat
	id = "hat"
	icon = "hat"
	name = "hat"
	screen_loc = "SOUTH,WEST"

/datum/inventory
	var/mob/parent
	var/throw_mode = FALSE
	var/selected_slot
	var/list/selectable
	var/hud/inventory/hud
	var/list/inventory_slot/slots

/datum/inventory/New(mob/mob)
	hud = new(mob)
	hud.inventory = src
	parent = mob
	selectable = list()
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
		if (S.selectable)
			selectable += S.id
			if (selected_slot)
				continue
			select_slot(S.id)
	hud.show()
	mob.click_intercept[src] = .proc/click_handler

/datum/inventory/proc/remove()
	for (var/P in slots)
		drop_item(P)
		var/inventory_slot/S = slots[P]
		S.inventory = null
	slots.Cut()
	if (hud.owner)
		hud.remove()

/datum/inventory/proc/click_handler(atom/object, location, control, params)
	var/obj/item/I = slots[selected_slot].item
	if (throw_mode)
		throw_mode = FALSE
		hud.ui_objects["throw"].icon_state = "throw"
		if (!I)
			return TRUE
		remove_item(selected_slot)
		I.loc = parent.loc
		var/range = abs(I.x - object.x) + abs(I.y - object.y)
		I.throw_at_atom(object, range, range * 2, pixel_position = TRUE)
		return TRUE
	if (!I)
		return FALSE
	if (object.loc == null)
		return FALSE
	var/mob/living/M = parent
	var/priority = M.kill_mode
	var/A = distance_pixel(usr, object) <= usr.interact_range
	if (params["left"])
		if (priority || !object.left_click(A, params, I))
			I.attack_left(object, A, params)
		return TRUE
	if (params["right"])
		if (priority || !object.right_click(A, params, I))
			I.attack_right(object, A, params)
		return TRUE
	return FALSE

/datum/inventory/proc/update()
	for (var/P in slots)
		hud.ui_objects[P].update_item()

/datum/inventory/proc/accept_item(slot, obj/item/I)
	return TRUE

/datum/inventory/proc/select_slot(slot)
	if (selected_slot)
		hud.ui_objects[selected_slot].icon_state = "slot"
	hud.ui_objects[slot].icon_state = "slot_a"
	selected_slot = slot

/datum/inventory/proc/insert_item(obj/item/I, slot)
	if (!I || slots[slot].item)
		return FALSE
	if (!accept_item(slot, I))
		return FALSE
	if (I.slot)
		remove_item(I.slot.id)
	I.loc = null
	slots[slot].item = I
	I.pixel_x = I.pixel_y = 0
	I.slot = slots[slot]
	hud.ui_objects[slot].update_item()
	I.inserted(src, slot)
	return TRUE

/datum/inventory/proc/remove_item(slot)
	if (!slots[slot].item)
		return null
	var/obj/item/I = slots[slot].item
	slots[slot].item = null
	I.slot = null
	if (hud.owner)
		hud.ui_objects[slot].update_item()
	I.removed(src, slot)
	return I

/datum/inventory/proc/drop_item(slot)
	var/obj/item/I = remove_item(slot)
	if (!I)
		return null
	I.loc = parent.loc
	I.dropped(src, slot)
	return I

/datum/inventory/player
	slots = list(
		/inventory_slot/l_hand,
		/inventory_slot/r_hand,
		/inventory_slot/hat
	)

/datum/inventory/player/accept_item(slot, obj/item/I)
	switch (slot)
		if ("hat")
			return istype(I, /obj/item/clothing/hat)
		else
			return TRUE

/datum/inventory/sigma
	slots = list(
		/inventory_slot/l_hand {
			id = "lhand2"
			screen_loc = "SOUTH,CENTER-1.5"
		},
		/inventory_slot/l_hand,
		/inventory_slot/r_hand,
		/inventory_slot/r_hand {
			id = "rhand2"
			screen_loc = "SOUTH,CENTER+1.5"
		}
	)