/datum/lock/pull/unlocked(atom/movable/who)
	who.glide_size = initial(who.glide_size)

/datum/lock/pull/moved(atom/movable/who)
	who.glide_size = locked_to.glide_size
	step(who, get_dir(who, last_position))

/obj/item/padlock
	name = "padlock"
	icon_state = "padlock"
	var/locked
	var/datum/lock/pull/lock

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