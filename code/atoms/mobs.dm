/mob
	maptext_y = -20
	maptext_x = -112
	maptext_width = 256
	icon = 'icons/mobs.dmi'
	say_verb = "says"
	var/interact_range = 1.5 // close enough to sqrt(2)
	var/can_interact = TRUE

/mob/New(loc)
	. = ..()
	update_maptext()

/mob/destroy()
	ghostize()
	return ..()

/mob/living/Login()
	. = ..()
	update_maptext()

/mob/living/Logout()
	. = ..()
	update_maptext()

/mob/proc/update_maptext()
	return

/mob/proc/ghostize()
	if (!key)
		return
	for (var/hud/H in huds)
		H.hide()
	var/mob/dead/ghost/G = new (loc)
	G.name = "ghost of [key ? key : name]"
	G.ckey = ckey
	G.update_maptext()

/mob/dead/take_damage(amount)
	return

/mob/dead/heal_damage(amount)
	return

/mob/dead/ghost
	name = "ghost"
	desc = "AAAAAAAAA!!"
	icon_state = "ghost"
	layer = OVER_LIGHTING_LAYER
	density = FALSE
	can_interact = FALSE
	sight = SEE_THRU
	movement_delay = 0.5
	invisibility = 50
	see_invisible = 50

/mob/dead/ghost/update_maptext()
	. = ..()
	maptext = CENTERTEXT(MAPTEXT("[key][client ? "" : " (DC)"]"))

/mob/living
	var/dead_state
	var/status = 0
	var/kill_mode = FALSE

/mob/living/New()
	. = ..()
	new /hud/status(src)

/mob/living/take_damage(amount)
	integrity -= amount
	update_maptext()
	if(!status && integrity <= 0)
		die()
	if(integrity < -max_integrity)
		destroy()

/mob/living/heal_damage(amount)
	. = ..()
	update_maptext()

/mob/living/get_movement_delay(loc, dir, turf/T)
	if (!istype(T))
		return ..()
	return movement_delay + T.slowdown

/mob/living/proc/die()
	status = 1
	density = FALSE
	layer = UNDER_MOB_LAYER
	icon_state = dead_state
	update_maptext()
	ghostize()

/mob/living/update_maptext()
	if(status)
		maptext = null
		return
	var/maptext_color
	var/health_percentage = round(integrity/max_integrity*100)
	switch(health_percentage)
		if(100 to INFINITY)
			maptext_color = "#00dd00"
		if(75 to 99)
			maptext_color = "#88bb00"
		if(50 to 74)
			maptext_color = "#aaaa00"
		if(25 to 49)
			maptext_color = "#bb8800"
		if(2 to 24)
			maptext_color = "#cc5500"
		if(-INFINITY to 1)
			maptext_color = "#dd0000"
	maptext = CENTERTEXT(MAPTEXT("[key ? "[name][client ? "" : " (DC)"]\n" : ""][SMALLTEXT("<font color='[maptext_color]'>[health_percentage]%</font>")]"))

/mob/living/inventory
	var/inventory_type
	var/datum/inventory/inventory

/mob/living/inventory/initialize(start)
	..()
	inventory = new inventory_type(src)

/mob/living/inventory/destroy()
	inventory.remove()
	..()

/mob/living/inventory/verb/switch_slot()
	set name = "Switch slot"
	set hidden = TRUE

	// only works with two selectable slots, but that is fine for now.
	for (var/id in inventory.selectable)
		if (inventory.selected_slot == id)
			continue
		inventory.select_slot(id)
		break

/mob/living/inventory/verb/drop()
	set name = "Drop"

	if (!inventory.selected_slot)
		return
	inventory.drop_item(inventory.selected_slot)

/mob/living/inventory/verb/use_hand()
	set name = "Use in-hand"
	set hidden = TRUE

	if (!inventory.selected_slot || !inventory.slots[inventory.selected_slot].item)
		return
	inventory.slots[inventory.selected_slot].item.attack_self(inventory, inventory.selected_slot)

/mob/living/inventory/player
	name = "Player"
	desc = "A cute cubeman."
	icon_state = "player"
	dead_state = "player_dead"
	rotatable = TRUE
	inventory_type = /datum/inventory/player
	//whether this player is super
	var/is_super = FALSE
	//speed at which the super animation runs, maximum 2 seconds to avoid epilepsy
	var/super_animation_speed = 60

/mob/living/inventory/player/die()
	//removes any special statuses
	animate(src, flags = ANIMATION_END_NOW)
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
	animate(src, color = "#00ff00", time = super_animation_speed)
	animate(color = "#0000ff", time = super_animation_speed)
	animate(color = "#ff0000", time = super_animation_speed)
	sleep(super_animation_speed * 3)
	if(status || !src)
		return
	become_super(setup = FALSE)
