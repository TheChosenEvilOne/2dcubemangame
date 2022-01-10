/obj/sign
	name = "sign"
	icon_state = "sign"
	var/message = ""

/obj/sign/left_click(adjacent, params, item)
	if (!istype(item, /obj/item/brush))
		usr << "The sign says:\n[message]"
		return
	if (!adjacent)
		return
	message = html_encode(input("What do you want the sign to say?", "sign editing", message) as null|message)
	if (!message)
		return

/obj/sign/examine_message()
	. = "The sign says:\n[message]"