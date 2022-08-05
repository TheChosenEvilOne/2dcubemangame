/mob/living/inventory
	var/inventory_type
	var/datum/inventory/inventory

/mob/living/inventory/initialize(start)
	..()
	inventory = new inventory_type(src)

/mob/living/inventory/destroy()
	inventory.remove()
	. = ..()

/mob/living/inventory/verb/switch_slot()
	set name = "Switch slot"
	set hidden = TRUE

	var/datum/inventory/I = inventory
	var/ind = I.selectable.Find(inventory.selected_slot)
	if (ind == I.selectable.len)
		I.select_slot(I.selectable[1])
	else
		I.select_slot(I.selectable[ind + 1])

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
	var/dying_animation = "player_dying"
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
	flick(dying_animation, src)
	..()

/mob/living/inventory/player/update_appearance()
	overlays.Cut()
	if (kill_mode)
		overlays += mutable_appearance(icon, "face_kill", appearance_flags = RESET_COLOR | PIXEL_SCALE)
	else
		overlays += mutable_appearance(icon, "face", appearance_flags = RESET_COLOR | PIXEL_SCALE)
	..()

/mob/living/inventory/player/projectile_impact(P)
	client?.glorf("OWW!!")
	. = ..()

/mob/living/inventory/player/proc/become_super(setup = TRUE)
	set waitfor = FALSE
	if (setup)
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

/mob/living/inventory/player/sigma
	desc = "The buffest cube around."
	interact_range = 90.5 // sqrt(2) * 64
	pixel_w = -16
	maptext_x = -96
	icon = 'icons/sigmacube.dmi'
	icon_state = "alive"
	dead_state = "dead"
	dying_animation = "dying"
	inventory_type = /datum/inventory/sigma