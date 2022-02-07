/turf/wall/rock
	name = "rock"
	icon_state = "rock"
	base_turf = /turf/floor/dort

/turf/wall/rock/destroy()
	if(prob(10))
		new /obj/item/rock(src)
	return ..()

/turf/wall/rock/gray
	name = "gray rock"
	icon_state = "rock_gray"
	base_turf = /turf/floor/dort

/obj/item/rock
	name = "rock"
	desc = "rock. can be used for crafting with wood, or for throwing at others."
	icon_state = "rock"

/obj/item/rock/hit_object(atom/A)
	A.take_damage(A.max_integrity / 10)
