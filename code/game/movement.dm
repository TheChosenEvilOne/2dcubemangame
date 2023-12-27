/atom/movable
	var/movement_type = GROUND

#define CHECK_DENSITY(T) \
if (T){if (T.bump(src)){T = null;}}

/atom/movable/Move(newloc, ndir = 0, force=FALSE)
	if (force)
		if (newloc)
			return loc = newloc
		else if (ndir)
			return loc = get_step(src, ndir)
	if (movement_type == FLYING)
		dir = ndir
		return loc = get_step(src, ndir)
	if (ndir)
		var/diag = ndir & (ndir - 1)
		if (diag)
			var/turf/T1 = get_step(src, diag)
			CHECK_DENSITY(T1)
			var/turf/T2 = get_step(src, ndir - diag)
			CHECK_DENSITY(T2)
			if (!(T1 || T2))
				return
			var/turf/D = get_step(src, ndir)
			CHECK_DENSITY(D)
			if (D)
				dir = diag
				return D.enter(src)
			else
				if (T1)
					dir = diag
					return T1.enter(src)
				else if (T2)
					dir = ndir - diag
					return T2.enter(src)
		else
			dir = ndir
			var/turf/T1 = get_step(src, ndir)
			CHECK_DENSITY(T1)
			if (!T1)
				return NONE
			return T1.enter(src)
	else
		if (istype(newloc, /turf))
			var/turf/T = newloc
			CHECK_DENSITY(T)
			if (T)
				dir = get_dir(src, T)
				return T.enter(src)
		else if(!isnull(newloc))
			return loc = newloc

/mob
	var/next_move = 0
	var/movement_delay = 1

/mob/proc/get_movement_delay(loc, dir, turf)
	return movement_delay

/turf/proc/get_slowdown(mob, dir)
	return slowdown

/client/Move(loc, dir)
	if (mob.next_move > world.time)
		return
	var/turf/T = get_step(mob, dir)
	var/diag = 1 + (0.41421 * !((dir - 1) & dir))
	var/delay = mob.get_movement_delay(loc, dir, T) * diag
	mob.next_move = world.time + delay
	mob.glide_size = DELAY2GLIDESIZE(delay)
	if (istype(T) && T.walk_sound)
		playsound(usr, "walk[T.walk_sound]", vol = 400)
	mob.Move(ndir = dir)

// From /vg/station13 - https://github.com/vgstation-coders/vgstation13
/client
	var/tmp
		mloop = 0
		move_dir = 0
		true_dir = 0
		keypresses = 0

var/static/list/opposite_dirs = list(SOUTH,NORTH,NORTH|SOUTH,WEST,SOUTHWEST,NORTHWEST,NORTH|SOUTH|WEST,EAST,SOUTHEAST,NORTHEAST,NORTH|SOUTH|EAST,WEST|EAST,WEST|EAST|NORTH,WEST|EAST|SOUTH,WEST|EAST|NORTH|SOUTH)

/client/verb/MoveKey(Dir as num, State as num)
	set hidden = TRUE
	set instant = TRUE

	if (!move_dir)
		. = 1
	var/opposite = opposite_dirs[Dir]
	if (State)
		move_dir |= Dir
		keypresses |= Dir
		if (opposite & keypresses)
			move_dir &= ~opposite
	else
		move_dir &= ~Dir
		keypresses &= ~Dir
		if (opposite & keypresses)
			move_dir |= opposite
		else
			move_dir |= keypresses

	true_dir = move_dir
	if(. && true_dir)
		move_loop()

/client/North()
/client/South()
/client/East()
/client/West()

// DO NOT ATTEMPT TO SYSTEMIFY THIS
// IF YOU DO, I AM PERSONALLY GOING TO EAT YOUR FACE.
/client/proc/move_loop()
	set waitfor = FALSE

	if (src.mloop) return
	mloop = TRUE
	src.Move(mob.loc, true_dir)
	while (src.true_dir)
		sleep (world.tick_lag)
		if (src.true_dir)
			src.Move(mob.loc, true_dir)
	mloop = FALSE