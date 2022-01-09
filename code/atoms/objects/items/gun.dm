/obj/item/gun
	name = "gun??"
	desc = "is this even a gun?"
	icon_state = "gun"

/obj/item/gun/attack_self()
	var/atom/movable/M = usr
	usr.act("shoots [M.p_possessive()].")
	usr.take_damage(M.integrity)

/obj/item/gun/attack_left(atom/target, adjacent, params)
	if (adjacent == INVENTORY_ADJACENT)
		return
	var/atom/movable/projectile/P = new(get_step(usr, 0), target)
	P.shoot(text2num(params["icon-x"]), text2num(params["icon-y"]))

/obj/item/gun/attack_right(atom/target, adjacent)
	if (adjacent == INVENTORY_ADJACENT)
		return
	usr.throw_at_atom(target, 1000)
