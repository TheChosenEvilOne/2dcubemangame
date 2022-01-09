/obj/item/injector
	name = "super injector"
	desc = "become the super cubemen you were always meant to be."
	icon_state = "injector"

/obj/item/injector/attack_self(datum/inventory/inventory, slot)
	var/mob/living/inventory/player/injected = usr
	if(!injected.is_super)
		injected.act("injects \the [src], becoming super!")
		injected.become_super()
	else
		injected.act("injects \the [src], becoming even MORE super!")
		injected.super_animation_speed = max(injected.super_animation_speed - 10, 20)
	hearers() << sound('sound/powerup.mp3')
	destroy()
