/datum/lock/magnifying_glass
	var/obj/item/magnifying_glass/item

/datum/lock/magnifying_glass/unlock

/datum/lock/magnifying_glass/moved(who)
	item.stop_viewing()

/obj/item/magnifying_glass
	name = "magnifying glass"
	desc = "magnifies glas- no, magnifies something."
	icon_state = "magnifying_glass"
	var/viewing = FALSE
	var/datum/lock/magnifying_glass/lock
	var/hud_object/icon/vicon = new()

/obj/item/magnifying_glass/initialize()
	. = ..()
	lock = new()
	lock.item = src
	vicon = new()
	vicon.transform *= 8

/obj/item/magnifying_glass/proc/stop_viewing()
	if (!viewing)
		return
	viewing = FALSE
	var/mob/M = lock.locked_to
	M.client.screen -= vicon
	sys_lock.unlock(src)
	vicon.vis_contents.Cut()
	vicon.overlays.Cut()

/obj/item/magnifying_glass/dropped(datum/inventory/I)
	stop_viewing()

/obj/item/magnifying_glass/attack_self(datum/inventory/I)
	stop_viewing()

/obj/item/magnifying_glass/attack_left(atom/target, adjacent)
	// turfs in vis_contents is a bit funny.
	if (adjacent != WORLD_ADJACENT || !istype(target, /atom/movable))
		return
	viewing = TRUE
	lock.lock(src, slot.inventory.parent)
	vicon.screen_loc = "CENTER,CENTER"
	if (istype(target, /obj/item/canvas))
		vicon.vis_contents += target
	else
		vicon.overlays += target.appearance
	usr.client.screen += vicon
	return TRUE