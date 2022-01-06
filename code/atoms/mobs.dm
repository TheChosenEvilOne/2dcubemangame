/mob
	icon = 'icons/mobs.dmi'
	say_verb = "says"
	var/interact_range = 1.5 // close enough to sqrt(2)
	var/can_interact = 1

/mob/destroy()
	var/mob/dead/ghost/G = new (loc)
	G.ckey = ckey
	del src

/mob/dead/ghost
	name = "ghost"
	desc = "AAAAAAAAA!!"
	icon_state = "ghost"
	density = 0
	can_interact = 0
	sight = SEE_THRU

/mob/inventory
	var/inventory_type
	var/datum/inventory/inventory

/mob/inventory/New()
	..()
	inventory = new inventory_type(src)

/mob/inventory/destroy()
	inventory.remove()
	..()

/mob/inventory/verb/drop()
	set name = "Drop"

	if (!inventory.selected_slot)
		return
	inventory.drop_item(inventory.selected_slot)

/mob/inventory/player
	name = "Player"
	desc = "A cute cubeman."
	icon_state = "player"
	rotatable = 1
	inventory_type = /datum/inventory/player

/mob/inventory/player/projectile_impact(P)
	say("OWW!!")
	. = ..()