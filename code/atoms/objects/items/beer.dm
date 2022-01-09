/obj/item/beer
	name = "beer"
	desc = "beer"
	icon_state = "beer"

/obj/item/beer/attack_self(datum/inventory/inventory, slot)
	usr.act("absorbs \the [src].")
	hearers() << sound('sound/belch.mp3')
	destroy()
