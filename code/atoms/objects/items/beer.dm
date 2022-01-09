/obj/item/beer
	name = "beer"
	desc = "beer"
	icon_state = "beer"
	var/heal_amount = 50

/obj/item/beer/attack_self(datum/inventory/inventory, slot)
	usr.act("absorbs \the [src].")
	usr.heal_damage(heal_amount)
	hearers() << sound('sound/belch.mp3')
	destroy()
