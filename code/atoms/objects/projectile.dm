/atom/movable/projectile
	name = "bullet"
	icon = 'icons/objs.dmi'
	icon_state = "bullet"
	animate_movement = NO_STEPS
	var/turn_icon = 1
	var/atom/target
	var/damage
	var/speed

/atom/movable/projectile/New(loc, trgt, dmg = 10, spd = 16)
	..(loc)
	if (!trgt)
		del src
	target = trgt
	damage = dmg
	speed = spd

/atom/movable/projectile/proc/shoot(x_offset = 16, y_offset = 16)
	set waitfor = FALSE
	if(!target)
		return 0
	var/xoff = target.x * 32 + x_offset - 16
	var/yoff = target.y * 32 + y_offset - 16
	var/angle = arctan(xoff - x * 32, yoff - y * 32)
	if (turn_icon) transform = turn(matrix(), -angle)
	var/dx = cos(angle) * speed
	var/dy = sin(angle) * speed
	while (1)
		pixel_x += dx
		pixel_y += dy

		if (pixel_x > 16)
			var/step = get_step(src, EAST)
			if (enter_turf(step) || !Move(step))
				break
			pixel_x -= 32
		else if (pixel_x < -16)
			var/step = get_step(src, WEST)
			if (enter_turf(step) || !Move(step))
				break
			pixel_x += 32

		if (pixel_y > 16)
			var/step = get_step(src, NORTH)
			if (enter_turf(step) || !Move(step))
				break
			pixel_y -= 32
		else if (pixel_y < -16)
			var/step = get_step(src, SOUTH)
			if (enter_turf(step) || !Move(step))
				break
			pixel_y += 32
		sleep (world.tick_lag)

	animate(src, alpha = 0, time = 100)
	spawn (100) del src

/atom/movable/projectile/proc/projectile_hit(atom/movable/A)
	return 0

/atom/movable/projectile/proc/enter_turf(turf/T)
	if (!T)
		return

	if (T.density)
		if (projectile_hit(T) || T.projectile_impact(src))
			return 0
		return 1

	for(var/k in T.contents)
		var/atom/movable/A = k
		if(!A.density)
			continue
		if (projectile_hit(A) || A.projectile_impact(src))
			return 0
		return 1