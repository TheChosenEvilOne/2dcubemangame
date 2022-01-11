/datum/lock
	var/last_position
	var/atom/movable/locked_to

/datum/lock/proc/lock(atom/movable/who, atom/movable/_locked_to)
	if (who == _locked_to)
		return FALSE
	locked_to = _locked_to
	return sys_lock.lock(who, src)

/datum/lock/proc/locked(atom/movable/who)

/datum/lock/proc/unlocked(atom/movable/who)

/datum/lock/proc/moved(atom/movable/who)
	who.loc = locked_to.loc

SYSTEM_CREATE(lock)
	name = "locking"
	flags = S_PROCESS
	update_rate = 0
	allocated_cpu = 0.2
	priority = 20
	var/list/datum/lock/locks = list()

/system/lock/process()
	for (var/atom/movable/who in locks)
		check_cpu
		var/datum/lock/L = locks[who]
		if (L.locked_to.loc == L.last_position)
			continue
		L.moved(who)
		L.last_position = L.locked_to.loc

/system/lock/proc/unlock(atom/movable/who)
	if (!locks[who])
		return FALSE
	locks[who].unlocked(who)
	locks[who] = null
	locks.Remove(who)
	return TRUE

/system/lock/proc/lock(atom/movable/who, datum/lock/L)
	if (locks[who])
		return FALSE
	L.last_position = L.locked_to.loc
	locks[who] = L
	return TRUE