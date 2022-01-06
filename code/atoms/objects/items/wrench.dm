/obj/item/wrench
	name = "wrench"
	desc = "wrench for rotating things."
	icon_state = "wrench"

/obj/item/wrench/attack_left(atom/target, adjacent)
	if (!target.rotatable || !adjacent)
		return
	target.dir = turn(target.dir, -90)

/obj/item/wrench/attack_right(atom/target, adjacent)
	if (!target.rotatable || !adjacent)
		return
	target.dir = turn(target.dir, 90)