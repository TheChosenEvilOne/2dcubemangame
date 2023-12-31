/obj/item/coconut
	name = "coconut"
	desc = "A coconut nut is a giant nut if you eat too much you get very fat!"
	icon_state = "coconut"
	max_integrity = 10

/obj/item/coconut/hit_object(atom/A)
	take_damage(rand(1,10))
	A.take_damage(A.max_integrity / 10)

/obj/item/coconut/destroy()
	new /obj/item/coconut_open(loc)
	new /obj/item/coconut_open(loc)
	return ..()

/obj/item/coconut_open
	name = "coconut"
	desc = "opened coconut, it is tasty!"
	icon_state = "coconut_open"
	var/heal_amount = 25

/obj/item/coconut_open/attack_self(datum/inventory/inventory, slot)
	usr.act("devours \the [src].")
	usr.heal_damage(heal_amount)
	playsound(usr, 'sound/crunch.mp3', vol = 100, range = 7)
	destroy()