/obj/item/pickaxe
	name = "pickaxe"
	desc = "pick for axing the rock."
	icon_state = "pickaxe"

/obj/item/pickaxe/attack_left(atom/target, adjacent)
	if (!adjacent || !istype(target, /turf/wall/rock))
		return
	target.destroy()
