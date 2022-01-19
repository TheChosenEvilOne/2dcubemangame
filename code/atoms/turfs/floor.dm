/turf/floor
	icon = 'icons/turfs/floors.dmi'

/turf/floor/gray
	name = "gray floor"
	icon_state = "gray"

/turf/floor/white
	name = "white floor"
	icon_state = "white"

/turf/floor/dort
	name = "dort"
	desc = "dir- dort??"
	icon_state = "dort0"
	variation = 1
	base_state = "dort"

/turf/floor/rocky
	name = "rocky path"
	icon_state = "rocky"

/turf/floor/grass
	name = "\proper grass"
	icon_state = "grass"

/turf/floor/wood
	name = "\proper wooden planks"
	icon_state = "planks"

/turf/floor/sand
	name = "\proper sand"
	icon_state = "sand0"
	variation = 2
	base_state = "sand"

/turf/floor/marsh
	name = "\proper marsh"
	icon_state = "marsh"
	slowdown = 0.5

/turf/floor/water
	name = "\proper water"
	icon_state = "water"
	slowdown = 1

/turf/floor/water/get_slowdown(mob, dir)
	if (locate(/obj/path) in src)
		return 0
	return slowdown

/turf/floor/water/lava
	name = "\proper lava"
	icon_state = "lava"
	light = 8
	datum_flags = DATUM_PROCESS
	processing_system = /system/processing/random
	var/damage_amount = 5

/turf/floor/water/lava/Crossed(atom/movable/atom)
	. = ..()
	if(locate(/obj/path) in src)
		return
	atom.take_damage(damage_amount*2)

/turf/floor/water/lava/process()
	if(locate(/obj/path) in src)
		return
	for(var/atom/movable/atom as anything in src)
		atom.take_damage(damage_amount)
