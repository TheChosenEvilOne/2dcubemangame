/atom/movable/abstract/lighting_overlay
	icon = 'icons/lighting.dmi'
	layer = LIGHTING_LAYER
	plane = LIGHTING_PLANE
	alpha = 0
	color = "black"
	var/list/sources = list()
	var/light_level

/atom/movable/abstract/lighting_overlay/initialize()
	set_light_level(sys_light.ambient_light[min(sys_light.ambient_light.len, z)])

/atom/movable/abstract/lighting_overlay/proc/add_light(light, source)
	if (sources[source])
		return
	sources[source] = light
	if (light <= light_level)
		return
	set_light_level(light)

/atom/movable/abstract/lighting_overlay/proc/remove_light(source)
	if (!sources[source])
		return
	var/L = sources[source]
	sources -= source
	if (L < light_level)
		return
	L = sys_light.ambient_light[min(sys_light.ambient_light.len, z)]
	if (sources.len)
		for (var/S in sources)
			if (sources[S] > L)
				L = sources[S]
	set_light_level(L)

var/const/light_mult = (255 / 15)
/atom/movable/abstract/lighting_overlay/proc/set_light_level(level)
	if (level == light_level)
		return
	light_level = level
	alpha = 255 - (light_mult * level)
