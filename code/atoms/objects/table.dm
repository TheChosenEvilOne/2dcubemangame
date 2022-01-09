/obj/table
	name = "table"
	desc = "it is a table, what did you expect?"
	icon_state = "table"
	density = TRUE

/obj/table/left_click(adjacent, params, item)
	if (!item)
		return
	var/obj/item/I = item
	I.slot.remove_item()
	I.loc = loc
	I.pixel_x = text2num(params["icon-x"]) - 16
	I.pixel_y = text2num(params["icon-y"]) - 16
	return TRUE