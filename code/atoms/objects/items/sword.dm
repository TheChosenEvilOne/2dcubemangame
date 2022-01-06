/obj/item/sword
	name = "sword"
	desc = "it seems awfully sharp despite what it looks like"
	icon_state = "sword"

/obj/item/sword/attack_left(atom/target, adjacent)
	if (!adjacent || istype(target, /turf))
		return
	target.destroy()
