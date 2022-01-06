/hud_object/slot
	icon_state = "slot"
	var/inventory_slot/slot

/hud_object/slot/Click(location, control, params)
	if (slot.item && slot.inventory.selected_slot == slot.id)
		slot.item.attack_self(slot.inventory, slot.id)
	hud.ui_objects[slot.inventory.selected_slot].icon_state = "slot"
	slot.inventory.selected_slot = slot.id
	icon_state = "slot_a"

/hud_object/slot/remove()
	slot = null

/hud_object/slot/proc/update_item()
	if (!slot.item)
		name = slot.name
		overlays.Cut()
	else
		name = slot.item.name
		overlays += slot.item