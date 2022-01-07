/mob
	icon = 'icons/mobs.dmi'
	say_verb = "says"
	var/interact_range = 1.5 // close enough to sqrt(2)
	var/can_interact = 1

/mob/Stat()
	stat("cpu", world.cpu)
	for (var/system/S in master.processing_systems)
		stat(S.name, "[S.firing] [S.next_fire] [S.allowed_cpu_time]")

/mob/destroy()
	if (key)
		var/mob/dead/ghost/G = new (loc)
		G.name = "ghost of [key ? key : name]"
		G.ckey = ckey
	..()

/mob/dead/ghost
	name = "ghost"
	desc = "AAAAAAAAA!!"
	icon_state = "ghost"
	density = 0
	can_interact = 0
	sight = SEE_THRU
	movement_delay = 0.5

/mob/living
	var/kill_mode = 0

/mob/living/New()
	. = ..()
	new /hud/status(src)

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
	rotatable = 1
	inventory_type = /datum/inventory/player

/mob/living/inventory/player/update_appearance()
	if (kill_mode)
		overlays -= "face"
		overlays += "face_kill"
	else
		overlays += "face"
		overlays -= "face_kill"


/mob/living/inventory/player/projectile_impact(P)
	say("OWW!!")
	. = ..()