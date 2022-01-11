/obj/item/canvas
	name = "canvas"
	icon_state = "canvas"
	var/icon/my_icon

/obj/item/canvas/initialize()
	. = ..()
	my_icon = icon(icon, "canvas")
	icon = my_icon