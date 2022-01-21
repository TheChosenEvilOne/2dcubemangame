/obj/item/clothing
	var/wear_slot
	var/pixel_offset_x = 0
	var/pixel_offset_y = 0
	var/worn_icon
	var/worn_icon_state

	var/mutable_appearance/worn

/obj/item/clothing/initialize()
	. = ..()
	worn = new
	worn.icon = worn_icon
	worn.icon_state = worn_icon_state
	worn.pixel_x = pixel_offset_x
	worn.pixel_y = pixel_offset_y

/obj/item/clothing/removed(datum/inventory/I, slot)
	if (slot == wear_slot)
		I.parent.overlays -= worn

/obj/item/clothing/inserted(datum/inventory/I, slot)
	if (slot == wear_slot)
		I.parent.overlays += worn