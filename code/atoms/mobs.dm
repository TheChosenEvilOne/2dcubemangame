/mob
	icon = 'icons/mobs.dmi'
	say_verb = "says"
	var/interact_range = 1.5 // close enough to sqrt(2)
	var/can_interact = 1

/mob/destroy()
	ghostize()
	..()

/mob/proc/ghostize()
	if (!key)
		return
	for (var/hud/H in huds)
		H.hide()
	var/mob/dead/ghost/G = new (loc)
	G.name = "ghost of [key ? key : name]"
	G.ckey = ckey

/mob/dead/ghost
	name = "ghost"
	desc = "AAAAAAAAA!!"
	icon_state = "ghost"
	layer = OVER_LIGHTING_LAYER
	density = 0
	can_interact = 0
	sight = SEE_THRU
	movement_delay = 0.5
	invisibility = 50
	see_invisible = 50

/mob/living
	var/dead_state
	var/status = 0
	var/kill_mode = 0

/mob/living/New()
	. = ..()
	new /hud/status(src)

/mob/living/take_damage(amount)
	if (!status && amount >= integrity)
		die()
	if (integrity < -max_integrity)
		destroy()
	integrity -= amount

/mob/living/get_movement_delay(loc, dir, turf/T)
	if (!istype(T))
		return ..()
	return movement_delay + T.slowdown

/mob/living/proc/die()
	status = 1
	density = 0
	layer = UNDER_MOB_LAYER
	icon_state = dead_state
	ghostize()

/mob/living/inventory
	var/inventory_type
	var/datum/inventory/inventory

/mob/living/inventory/initialize(start)
	..()
	inventory = new inventory_type(src)

/mob/living/inventory/destroy()
	inventory.remove()
	..()

/mob/living/inventory/verb/drop()
	set name = "Drop"

	if (!inventory.selected_slot)
		return
	inventory.drop_item(inventory.selected_slot)

/mob/living/inventory/player
	name = "Player"
	desc = "A cute cubeman."
	icon_state = "player"
	dead_state = "player_dead"
	rotatable = 1
	inventory_type = /datum/inventory/player
	var/is_super = FALSE
	//speed at which the super animation runs, maximum 2 seconds to avoid epilepsy
	var/super_animation_speed = 60

/mob/living/inventory/player/die()
	//removes any special statuses
	icon_state = initial(icon_state)
	animate(src)
	overlays.Cut()
	flick("player_dying", src)
	..()

/mob/living/inventory/player/update_appearance()
	overlays.Cut()
	if (kill_mode)
		overlays += mutable_appearance(icon, "face_kill", appearance_flags = RESET_COLOR)
	else
		overlays += mutable_appearance(icon, "face", appearance_flags = RESET_COLOR)

/mob/living/inventory/player/projectile_impact(P)
	say("OWW!!")
	. = ..()

/mob/living/inventory/player/proc/become_super(setup = TRUE)
	set waitfor = FALSE
	if(setup)
		is_super = TRUE
		icon_state = "super_player"
		color = "#ff0000"
	animate(src, color = "#00ff00", super_animation_speed)
	sleep(super_animation_speed)
	if(status || !src)
		return
	animate(src, color = "#0000ff", super_animation_speed)
	sleep(super_animation_speed)
	if(status || !src)
		return
	animate(src, color = "#ff0000", super_animation_speed)
	sleep(super_animation_speed)
	if(status || !src)
		return
	become_super(setup = FALSE)
