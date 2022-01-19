/obj/item/injector
	name = "super injector"
	desc = "become the super cubemen you were always meant to be."
	icon_state = "injector"

/obj/item/injector/attack_self(datum/inventory/inventory, slot)
	var/mob/living/inventory/player/injected = usr
	if (injected.is_sigma)
		usr << "Your skin is too thick for the injector to pierce!"
		return
	if (!injected.is_super)
		injected.act("injects \the [src], becoming super!")
		injected.become_super()
	else
		injected.act("injects \the [src], becoming even MORE super!")
		injected.super_animation_speed = max(injected.super_animation_speed - 10, 20)
	hearers() << sound('sound/powerup.mp3')
	destroy()

/obj/item/injector/steroids
	name = "steroid injector"
	desc = "become the sigma cubeman."
	icon_state = "steroids"

/obj/item/injector/attack_self(datum/inventory/inventory, slot)
	var/mob/living/inventory/player/injected = usr
	if (injected.is_sigma)
		usr << "You are already the gigachad cubeman."
		return
	if (injected.is_super)
		usr << "You are super, you can't get buff now."
		return
	injected.act("injects \the [src], becoming buff!")
	injected.is_sigma = TRUE
	injected.update_appearance()
	destroy()
