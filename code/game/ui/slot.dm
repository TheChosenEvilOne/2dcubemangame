/hud_object/slot
	icon_state = "slot"
	var/hud_object/slot_item/slicon = new()
	var/inventory_slot/slot

/hud_object/slot/setup()
	slicon.slot = slot
	slicon.layer = layer+1
	slicon.screen_loc = screen_loc

/hud_object/slot/Click(location, control, params)
	if (!slot.selectable)
		if (!slot.inventory.selected_slot)
			return
		slot.inventory.insert_item(slot.inventory.slots[slot.inventory.selected_slot].item, slot)
		return
	if (slot.inventory.selected_slot == slot)
		return
	hud.ui_objects[slot.inventory.selected_slot].icon_state = "slot"
	slot.inventory.selected_slot = slot.id
	icon_state = "slot_a"

/hud_object/slot/remove()
	slicon.slot = null
	slicon = null
	slot = null

/hud_object/slot/show(client/C)
	C.screen += slicon

/hud_object/slot/hide(client/C)
	C.screen -= slicon

/hud_object/slot/proc/update_item()
	if (!slot.item)
		slicon.name = ""
		slicon.overlays.Cut()
	else
		slicon.name = slot.item.name
		slicon.overlays += slot.item

/hud_object/slot_item
	name = ""
	var/inventory_slot/slot

/hud_object/slot_item/Click(location, control, params)
	// if you somehow click this without it having item, I honestly want to know
	var/selected = slot.inventory.selected_slot
	if (selected != slot.id)
		if (!slot.inventory.slots[selected].item)
			slot.inventory.insert_item(slot.item, selected)
			return
		var/P = params2list(params)
		if (P["left"])
			slot.inventory.slots[selected].item.attack_left(slot.item, INVENTORY_ADJACENT, P)
		else if (P["right"])
			slot.inventory.slots[selected].item.attack_right(slot.item, INVENTORY_ADJACENT, P)
		return
	slot.item.attack_self(slot.inventory, slot.id)
