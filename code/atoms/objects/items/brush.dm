/obj/item/brush
	name = "brush"
	icon_state = "brush"
	desc = "You can use this to paint or write."
	var/painting_color = "#fff"

/obj/item/brush/attack_self()
	painting_color = input("select color") as null|color
	if (!painting_color)
		painting_color = "#fff"

/obj/item/brush/attack_left(atom/target, adjacent, params)
	if (adjacent != WORLD_ADJACENT || !istype(target, /obj/item/canvas))
		return
	var/obj/item/canvas/C = target
	var/icon_x = text2num(params["icon-x"])
	var/icon_y = text2num(params["icon-y"])
	C.my_icon.DrawBox(painting_color, icon_x, icon_y)
	C.icon = C.my_icon

/obj/item/brush/attack_right(atom/target, adjacent, params)
	if (adjacent != WORLD_ADJACENT || !istype(target, /obj/item/canvas))
		return
	var/obj/item/canvas/C = target
	var/icon_x = text2num(params["icon-x"])
	var/icon_y = text2num(params["icon-y"])
	C.my_icon.DrawBox("#fff", icon_x, icon_y)
	C.icon = C.my_icon