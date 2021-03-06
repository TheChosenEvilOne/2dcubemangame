/datum/lock/pull/locked(atom/movable/who)
	if (istype(who, /obj/item)) // HACK: thrown items have pixel offsets set, so.
		who.pixel_x = who.pixel_y = 0

/datum/lock/pull/unlocked(atom/movable/who)
	who.glide_size = initial(who.glide_size)

/datum/lock/pull/moved(atom/movable/who)
	who.glide_size = locked_to.glide_size
	if (!who.Move(last_position))
		sys_lock.unlock(who)

/obj/item/padlock
	name = "padlock"
	icon_state = "padlock"
	var/locked
	var/datum/lock/pull/lock

/obj/item/padlock/destroy()
	sys_lock.unlock(locked)
	. = ..()

/obj/item/padlock/attack_left(atom/target, adjacent)
	if (adjacent != WORLD_ADJACENT || !istype(target, /atom/movable))
		return
	if (lock)
		sys_lock.unlock(locked)
	else
		lock = new()
	locked = target
	lock.lock(target, usr)

/obj/item/padlock/attack_self()
	sys_lock.unlock(locked)