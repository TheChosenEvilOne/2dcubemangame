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
	var/T = get_step(mob, dir)
	var/diag = 1 + (0.41421 * (((dir - 1) & dir) != 0))
	var/delay = mob.get_movement_delay(loc, dir, T) * diag
	mob.next_move = world.time + delay
	mob.glide_size = DELAY2GLIDESIZE(delay)
	..(T)

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