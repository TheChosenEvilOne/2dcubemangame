/obj/item/sword
	name = "sword"
	desc = "it seems awfully sharp despite what it looks like"
	icon_state = "sword"

/obj/item/sword/attack_left(atom/target, adjacent)
	if (!adjacent || istype(target, /turf))
		return
	usr.act("hits [target] with \the [src].")
	target.take_damage(target.max_integrity / 2)

/obj/item/sword/hit_object(atom/A)
	if (istype(A, /turf))
		return
	A.take_damage(A.max_integrity / 2)

/obj/item/sword/amogus
	name = "sword"
	desc = "for some reason this sword can only hit mobs"
	icon_state = "sword"

/obj/item/sword/amogus/attack_left(atom/target, adjacent)
	if (!adjacent || istype(target, /mob/living))
		return
	usr.act("stabs [target] with \the [src].")
	target.take_damage(target.max_integrity / 2)

/obj/item/sword/amogus/hit_object(atom/A)
	if (istype(A, /mob/living))
		return
	A.take_damage(A.max_integrity / 2)
