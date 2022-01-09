/obj/item/beer
	name = "beer"
	desc = "beer"
	icon_state = "beer"

/obj/item/beer/attack_self(datum/inventory/inventory, slot)
	usr.act("absorbs \the [src].")
	hearers() << sound('sound/belch.mp3')
	var/I = usr.filters.len + 1
	usr.filters += filter(type="wave", x=20, y=10, size=4)
	var/F = usr.filters[I]
	animate(F, offset=0, time=0, loop=-1, flags=ANIMATION_PARALLEL)
	animate(offset=1, time=rand()*20+10)
	destroy()
