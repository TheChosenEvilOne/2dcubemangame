// This is awful, please rework this into something nicer.
/obj/item/clothing
	var/wear_slot
	var/pixel_offset_x = 0
	var/pixel_offset_y = 0
	var/worn_icon
	var/worn_icon_state

	var/mutable_appearance/worn

/obj/item/clothing/initialize()
	. = ..()
	worn = mutable_appearance(worn_icon, worn_icon_state)
	worn.transform = worn.transform.Translate(pixel_offset_x, pixel_offset_y) // BYOND can't really move only the icon.
	worn.layer = FLOAT_LAYER + 0.1

// doing it this way is awful.
/obj/item/clothing/removed(datum/inventory/I, slot)
	if (slot == wear_slot)
		I.parent.remove_managed_overlay(wear_slot)

/obj/item/clothing/inserted(datum/inventory/I, slot)
	if (slot == wear_slot)
		I.parent.add_managed_overlay(wear_slot, worn)