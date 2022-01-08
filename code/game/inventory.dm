/inventory_slot
	var/id
	var/name = "Inventory Slot"
	var/screen_loc = "0,0"
	var/selectable = 0
	var/datum/inventory/inventory
	var/obj/item/item

/inventory_slot/proc/remove_item()
	return inventory.remove_item(id)

/inventory_slot/l_hand
	id = "lhand"
	name = "left hand"
	screen_loc = "SOUTH,CENTER-0.5"

/inventory_slot/r_hand
	id = "rhand"
	name = "right hand"
	screen_loc = "SOUTH,CENTER+0.5"

/datum/inventory
	var/mob/parent
	var/throw_mode = 0
	var/selected_slot
	var/hud/inventory/hud
	var/list/inventory_slot/slots

/datum/inventory/New(mob/mob)
	hud = new(mob)
	hud.inventory = src
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
	var/obj/item/I = slots[selected_slot].item
	if (throw_mode)
		throw_mode = 0
		hud.ui_objects["throw"].icon_state = "throw"
		if (!I)
			return 1
		remove_item(selected_slot)
		I.loc = parent.loc
		I.throw_at_atom(object, abs(I.x - object.x) + abs(I.y - object.y), keep_pos = 1)
		return 1
	if (!I)
		return 0
	if (object == I)
		I.attack_self()
		return 0
	if (object.loc == null)
		return 0
	var/mob/living/M = parent
	var/priority = M.kill_mode ? 1 : 0
	var/A = get_dist(usr, object) <= usr.interact_range
	if (params["left"])
		if (priority || !object.left_click(A, params, I))
			I.attack_left(object, A, params)
	if (params["right"])
		if (priority || !object.right_click(A, params, I))
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
	I.pixel_x = I.pixel_y = 0
	I.slot = slots[slot]
	hud.ui_objects[slot].update_item()
	return 1

/datum/inventory/proc/remove_item(slot)
	if (!slots[slot].item)
		return 0
	var/obj/item/I = slots[slot].item
	slots[slot].item = null
	I.slot = null
	hud.ui_objects[slot].update_item()
	return I

/datum/inventory/proc/drop_item(slot)
	var/obj/item/I = remove_item(slot)
	if (!I)
		return 0
	I.loc = parent.loc

/datum/inventory/player
	slots = list(
		/inventory_slot/l_hand,
		/inventory_slot/r_hand
	)