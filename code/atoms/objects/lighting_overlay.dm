/atom/movable/lighting_overlay
	icon = 'icons/lighting.dmi'
	layer = LIGHTING_LAYER
	plane = LIGHTING_PLANE
	alpha = 0
	mouse_opacity = 0
	var/source
	var/light_level = 0

/atom/movable/lighting_overlay/initialize()
	set_light_level(4)
	if (!sys_light) // XXX: Remove this once system priority is implemented
		return
	light_level = sys_light.ambient_light
	sys_light.propagate_light(get_step(src, 0), light_level)

var/const/light_mult = (255 / 15)
/atom/movable/lighting_overlay/proc/set_light_level(level)
	if (level == light_level)
		return
	light_level = level
	alpha = 255 - (light_mult * level)

/atom/movable/lighting_overlay/take_damage(amount)
	return

/atom/movable/lighting_overlay/heal_damage(amount)
	return
